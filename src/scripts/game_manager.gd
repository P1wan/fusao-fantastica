extends Node
class_name GameManager

@export var hint_delay : float = 5    # seconds inside before showing hint
@onready var ui_label : Label = get_tree().get_current_scene().get_node("Main/ScrollController/Camera2D/UI/HintPanel/HintLabel") 
@onready var ui_panel : Panel = get_tree().get_current_scene().get_node("Main/ScrollController/Camera2D/UI/HintPanel")    # panel to show/hide

var _hint_timers : Dictionary = {}       # flag -> elapsed seconds
var shape_change_panel: Panel = null
var game_flag1_ref: GameFlag = null
var panel2: Panel = null
var game_flag2_ref: GameFlag = null
var _current_timer: SceneTreeTimer = null

func _ready():
	# Try to get references to GameFlag1, GameFlag2, and the panels
	if get_tree().get_current_scene().has_node("HintsAndMessages/ShapeChangeHint/Panel"):
		shape_change_panel = get_tree().get_current_scene().get_node("HintsAndMessages/ShapeChangeHint/Panel")
	if get_tree().get_current_scene().has_node("GameFlag1"):
		game_flag1_ref = get_tree().get_current_scene().get_node("GameFlag1")
	if get_tree().get_current_scene().has_node("HintsAndMessages/ShapeChangeHint/Panel2"):
		panel2 = get_tree().get_current_scene().get_node("HintsAndMessages/ShapeChangeHint/Panel2")
	if get_tree().get_current_scene().has_node("GameFlag2"):
		game_flag2_ref = get_tree().get_current_scene().get_node("GameFlag2")

	GameMaster.register_ui(ui_label, ui_panel)

func register_ui(label: Label, panel: Panel) -> void:
	ui_label = label
	ui_panel = panel

func _physics_process(delta):
	var to_remove := []
	for flag in _hint_timers.keys():
		_hint_timers[flag] += delta
		if _hint_timers[flag] >= hint_delay:
			_show_text(flag.hint_text, flag)
			to_remove.append(flag)
	for f in to_remove:
		_hint_timers.erase(f)

func flag_enter(player: Player, flag: GameFlag) -> void:
	print("flag_enter called for flag:", flag, "with text:", flag.hint_text)
	match flag.flag_type:
		GameFlag.FlagType.HINT:
			# Only use required_character for hints
			_hint_timers[flag] = 0.0
			print("Started hint timer for flag")
		GameFlag.FlagType.SUCCESS:
			# Show success message regardless of character
			if not flag.has_meta("success_shown"):
				_show_text(flag.hint_text)
				flag.set_meta("success_shown", true)

func flag_exit(_player: Player, flag: GameFlag) -> void:
	print("GameManager: flag_exit called with flag ", flag)
	_hint_timers.erase(flag)
	print("Removed hint timer for flag")

func _show_text(msg: String, flag: GameFlag = null) -> void:
	print("SHOW_TEXT CALLED WITH:", msg)
	if ui_label and ui_panel:
		print("ui_label and ui_panel are valid")
		ui_label.text = msg
		ui_panel.visible = true
	else:
		print("ERROR: ui_label or ui_panel not set!", ui_label, ui_panel)

func _on_hint_timeout():
	if ui_panel:
		ui_panel.visible = false
	_current_timer = null
