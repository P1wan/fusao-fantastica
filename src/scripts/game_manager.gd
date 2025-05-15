extends Node
class_name GameManager

@export var hint_delay : float = 5    # seconds inside before showing hint
@onready var ui_label : Label = null     # link after scene is running

var _hint_timers : Dictionary = {}       # flag -> elapsed seconds

func register_ui(label: Label) -> void:
	ui_label = label

func _physics_process(delta):
	var to_remove := []
	for flag in _hint_timers.keys():
		_hint_timers[flag] += delta
		if _hint_timers[flag] >= hint_delay:
			_show_text(flag.hint_text)
			to_remove.append(flag)
	for f in to_remove:
		_hint_timers.erase(f)

func flag_enter(player: Player, flag: GameFlag) -> void:
	print("GameManager: flag_enter called with ", player, " and ", flag)
	match flag.flag_type:
		GameFlag.FlagType.HINT:
			_hint_timers[flag] = 0.0
			print("Started hint timer for flag")
		GameFlag.FlagType.SUCCESS:
			if player.current == flag.required_character:
				if not flag.has_meta("success_shown"):
					_show_text(flag.hint_text)
					flag.set_meta("success_shown", true)

func flag_exit(_player: Player, flag: GameFlag) -> void:
	print("GameManager: flag_exit called with flag ", flag)
	_hint_timers.erase(flag)
	print("Removed hint timer for flag")

func _show_text(msg: String) -> void:
	print("Showing text: ", msg)
	if ui_label:
		ui_label.text = msg
		ui_label.visible = true
		ui_label.modulate = Color.WHITE
		ui_label.create_tween().tween_property(ui_label, "modulate:a", 0, 2).set_trans(Tween.TRANS_QUAD)
	else:
		print("ERROR: ui_label not set!")
