# -------- CONFIG -------------------------------------------------
const TILE_MAP_SCN  := "res://src/scenes/test_tutorial.tscn"
const LAYER_NODE    := "TileMapLayer"
const ASCII_FILE    := "res://levels/tutorial_ascii.txt"

# mapeia caractere → { source:int, atlas:Vector2i }
var SYMBOLS = {
    "▮": { "s": 2, "uv": Vector2i(9,0) },   # bloco cheio (world_tileset 0,0)
    "=": { "s": 2, "uv": Vector2i(3,0) },   # plataforma one-way (linha de grama?)
    ">": { "s": 2, "uv": Vector2i(15,1) },   # placa decorativa (Assets.png)
    "#": { "s": 2, "uv": Vector2i(18,0) },   # tile invisível (ou qualquer decor)
    "✪":{ "s": 1, "uv": Vector2i(20,1)},    # bandeira/portal (Other Assets.png)
}

# caracteres que instanciam cenas em vez de tile
var SCENES = {
    "o": "res://src/scenes/stone.tscn"
}

func _run() -> void:
    var scene := load(TILE_MAP_SCN) as PackedScene
    var root  := scene.instantiate()
    var map   := root.get_node(LAYER_NODE) as TileMapLayer
    var TILE_SIZE : Vector2 = map.tile_set.tile_size   # usa o size do TileSet
    if map == null:
        push_error("Node '%s' não encontrado!" % LAYER_NODE)
        return

    # limpa camada 0
    map.clear()

    # lê ASCII (remove linhas vazias e inverte Y p/ ficar chão em baixo)
    var lines := []
    for raw_line in FileAccess.open(ASCII_FILE, FileAccess.READ).get_as_text().split("\n"):
        var line := raw_line.strip_edges()
        if line == "" or line.begins_with("#"):
            continue             # pula linha vazia ou comentário
        lines.append(line)
    lines.reverse()

    for y in lines.size():
        var row = lines[y]
        for x in row.length():
            var ch: String = row.substr(x, 1)   # garante string
            if ch == ".":
                continue
            if SYMBOLS.has(ch):
                var entry = SYMBOLS[ch]

                var info: Dictionary
                if entry is Array:
                    info = entry[randi() % entry.size()]      # variedade
                else:
                    info = entry                               # único tile

                map.set_cell(Vector2i(x, y), info.s, info.uv)
            elif SCENES.has(ch):
                var inst: Node2D = (load(SCENES[ch]) as PackedScene).instantiate()
                root.add_child(inst)
                inst.position = (Vector2(x, y) + Vector2(0.5, 0.5)) * TILE_SIZE
            else:
                continue         # ignora texto extra como se fosse ar

    # salva alteração no próprio .tscn
    ResourceSaver.save(scene, TILE_MAP_SCN)
    print("Tutorial gerado a partir do ASCII! (salvo em %s)" % TILE_MAP_SCN) 