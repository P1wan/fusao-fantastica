extends Node2D

@onready var dialogue_label: RichTextLabel = $Dialogue
@onready var continue_label: Label = $PressToContinue

var step := 0
var dialogues := [
	"Rafa, Bia e Tonico se perderam do grupo em uma excursão, atraídos por uma luz azul misteriosa, eles caíram em um portal para outro mundo",
	"Eles sentem suas formas desaparecendo, seus corpos se fundindo em um só...",
	"Eles ouvem a voz de um mago sábio: 'Vocês precisarão trabalhar juntos para escapar deste lugar!'"
]
var musics := ["fusion_theme", null, "elron_theme"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	step = 0
	dialogue_label.text = dialogues[step]
	continue_label.visible = true
	get_node("/root/AudioManager").play_music("fusion_theme")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		advance_cutscene()

func advance_cutscene():
	step += 1
	if step == 1:
		dialogue_label.text = dialogues[step]
	elif step == 2:
		dialogue_label.text = dialogues[step]
		get_node("/root/AudioManager").play_music("elron_theme")
	elif step == 3:
		get_tree().change_scene_to_file("res://src/scenes/main.tscn")
