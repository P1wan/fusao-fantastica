@tool
extends EditorScript
#
#  ASCII  →  TileMapLayer  (Godot 4.3) – atua NA cena aberta
#

# -------- CONFIG -------------------------------------------------
const LAYER_NODE : String  = "TileMapLayer"
const ASCII_FILE : String  = "res://levels/tutorial_ascii.txt"

# caractere → { source_id:int, uv:Vector2i }  (ajuste às coords do seu TileSet)
var SYMBOLS : Dictionary = {
    # ─── plataformas (One-Way) ──────────────────────────
    "U":[{"s":1,"uv":Vector2i(18,14)}],  # madeira A L
    "V":[{"s":1,"uv":Vector2i(19,14)}],  # madeira A M1
    "W":[{"s":1,"uv":Vector2i(20,14)}],  # madeira A M2
    "X":[{"s":1,"uv":Vector2i(21,14)}],  # madeira A R

    "Y":[{"s":1,"uv":Vector2i(15,16)}],  # madeira B L
    "Z":[{"s":1,"uv":Vector2i(16,16)}],  # madeira B M
    "@":[{"s":1,"uv":Vector2i(17,16)}],  # madeira B R

    "G":[{"s":1,"uv":Vector2i(14,4)}],   # galho alto L
    "H":[{"s":1,"uv":Vector2i(15,4)}],   # galho alto M
    "I":[{"s":1,"uv":Vector2i(16,4)}],   # galho alto R

    "J":[{"s":1,"uv":Vector2i(14,6)}],   # galho baixo L
    "K":[{"s":1,"uv":Vector2i(15,6)}],   # galho baixo M
    "L":[{"s":1,"uv":Vector2i(16,6)}],   # galho baixo R

    "E":[{"s":1,"uv":Vector2i(20,5)}],   # galho espesso L
    "F":[{"s":1,"uv":Vector2i(21,5)}],   # galho espesso M
    "R":[{"s":1,"uv":Vector2i(22,5)}],   # galho espesso R

    "g":[{"s":2,"uv":Vector2i(2,0)}],
    "h":[{"s":2,"uv":Vector2i(3,0)}],
    "i":[{"s":2,"uv":Vector2i(4,0)}],

    # ─── terreno sólido (variedade) ─────────────────────
    "s":[{"s":1,"uv":Vector2i(16,2)}],
    "t":[{"s":1,"uv":Vector2i(11,3)}],
    "u":[{"s":2,"uv":Vector2i(1,10)}],
    "v":[{"s":2,"uv":Vector2i(2,10)}],
    "w":[{"s":2,"uv":Vector2i(3,10)}],
    "x":[{"s":2,"uv":Vector2i(4,10)}],
    "y":[{"s":2,"uv":Vector2i(5,10)}],

    # ─── decoração (sem colisão) ────────────────────────
    "a":[{"s":2,"uv":Vector2i(13,0)}],
    "f":[{"s":2,"uv":Vector2i(14,0)}],
    "k":[{"s":2,"uv":Vector2i(15,0)}],
    "m":[{"s":2,"uv":Vector2i(13,1)}],
    "n":[{"s":2,"uv":Vector2i(14,1)}],
    "o":[{"s":2,"uv":Vector2i(15,1)}],
    "q":[{"s":2,"uv":Vector2i(14,2)}],
    "r":[{"s":2,"uv":Vector2i(15,2)}],

    # ─── blocos 2×2 pedra (source 1) ────────────────────
    "P":[{"s":1,"uv":Vector2i(11,4)}], # sup-esq
    "Q":[{"s":1,"uv":Vector2i(12,4)}], # sup-dir
    "S":[{"s":1,"uv":Vector2i(11,5)}], # inf-esq
    "T":[{"s":1,"uv":Vector2i(12,5)}], # inf-dir

    # ─── blocos 2×2 pedra (source 2) ────────────────────
    "1":[{"s":2,"uv":Vector2i(7,2)}],   # sup-esq   (antes "H1")
    "2":[{"s":2,"uv":Vector2i(8,2)}],   # sup-dir   (antes "J1")
    "3":[{"s":2,"uv":Vector2i(7,3)}],   # inf-esq   (antes "K1")
    "4":[{"s":2,"uv":Vector2i(8,3)}],   # inf-dir   (antes "L1")

    # ─── bloco 2×2 arbusto redondo ─────────────────────
    "B":[{"s":2,"uv":Vector2i(16,0)}], # sup-esq
    "C":[{"s":2,"uv":Vector2i(17,0)}], # sup-dir
    "D":[{"s":2,"uv":Vector2i(16,1)}], # inf-esq
    "e":[{"s":2,"uv":Vector2i(17,1)}], # inf-dir  (H reaproveitado? use alguma outra, p.ex. 'E2')
}

# caracteres que instanciam cenas
var SCENES : Dictionary = {
    "o": "res://src/scenes/stone.tscn"
}
# ----------------------------------------------------------------

func _run() -> void:
    # 1. pega a cena que já está aberta no editor
    var root := get_editor_interface().get_edited_scene_root()
    if root == null:
        push_error("Abra a cena do tutorial antes de rodar o plug-in.")
        return

    # 2. localiza o TileMapLayer
    var map := root.get_node_or_null(LAYER_NODE) as TileMapLayer
    if map == null:
        push_error("Node '%s' não encontrado." % LAYER_NODE)
        return

    var TILE_SIZE : Vector2 = map.tile_set.tile_size

    # 3. limpa e repinta
    map.clear()

    var raw_text := FileAccess.open(ASCII_FILE, FileAccess.READ).get_as_text()
    var lines : PackedStringArray = []
    for l in raw_text.split("\n"):
        var line := l.strip_edges()
        if line == "" or line.begins_with("#"):
            continue            # ignora linhas vazias ou comentário
        lines.append(line)
    lines.reverse()             # linha de baixo vira y = 0

    for y in lines.size():
        var row := lines[y]
        for x in row.length():
            var ch : String = row.substr(x, 1)
            match ch:
                ".":
                    continue
                _:
                    if SYMBOLS.has(ch):
                        var entry = SYMBOLS[ch]
                        var info : Dictionary        # ← já declara

                        if entry is Array:
                            # sorteia uma das variações
                            info = entry[randi() % entry.size()]
                        else:
                            # já é Dictionary único
                            info = entry as Dictionary

                        map.set_cell(Vector2i(x, y), info.s, info.uv)
                    elif ch == " ":
                        continue
                    elif SCENES.has(ch):
                        var inst : Node2D = (load(SCENES[ch]) as PackedScene).instantiate()
                        root.add_child(inst)
                        inst.position = (Vector2(x, y) + Vector2(0.5, 0.5)) * TILE_SIZE
                    # caracteres não mapeados são ignorados

    print("Tutorial gerado na cena aberta — lembre-se de dar Ctrl + S se quiser salvar!")
