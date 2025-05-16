extends Node
class_name GameManager

@export var hint_delay : float = 5    # seconds inside before showing hint
@onready var ui_label : Label = null     # link after scene is running

var _hint_timers : Dictionary = {}       # flag -> elapsed seconds
var shape_change_panel: Panel = null
var game_flag1_ref: GameFlag = null
var panel2: Panel = null
var game_flag2_ref: GameFlag = null

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

func register_ui(label: Label) -> void:
	ui_label = label

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
	print("GameManager: flag_enter called with ", player, " and ", flag)
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
	print("Showing text: ", msg)
	if ui_label:
		ui_label.text = msg
		ui_label.visible = true
		ui_label.modulate = Color.WHITE
		ui_label.create_tween().tween_property(ui_label, "modulate:a", 0, 2).set_trans(Tween.TRANS_QUAD)
		# If this is GameFlag1, unhide the panel
		if flag != null and game_flag1_ref != null and flag == game_flag1_ref and shape_change_panel:
			shape_change_panel.visible = true
		# If this is GameFlag2, unhide Panel2
		if flag != null and game_flag2_ref != null and flag == game_flag2_ref and panel2:
			panel2.visible = true
	else:
		print("ERROR: ui_label not set!")
