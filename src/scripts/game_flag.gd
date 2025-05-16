extends Area2D
class_name GameFlag

signal player_enter(player: Player, flag: GameFlag)
signal player_exit(player: Player, flag: GameFlag)

enum FlagType { HINT, SUCCESS }

@export var flag_type : FlagType = FlagType.HINT
@export var required_character : Player.Character = Player.Character.RAFA   # only for SUCCESS
@export var hint_text : String = "Tente trocar de personagem!"
@export var hint_delay : float = 5.0 # seconds until hint appears
@export var message_duration : float = 2.0 # seconds message stays visible
@export var collision_width : float = 32.0 # width of the collision shape
@export var collision_height : float = 32.0 # height of the collision shape

func _ready() -> void:
	print("GameFlag ready: ", self)
	# Set collision shape size if a RectangleShape2D is present
	var shape_node = $CollisionShape2D if has_node("CollisionShape2D") else null
	if shape_node and shape_node.shape is RectangleShape2D:
		shape_node.shape.size = Vector2(collision_width, collision_height)
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	
	# Forward custom signals straight to the singleton - access it properly
	var game_manager = GameMaster
	print("Connecting signals to game_manager: ", game_manager)
	
	if game_manager:
		player_enter.connect(game_manager.flag_enter)
		player_exit.connect(game_manager.flag_exit)
	else:
		print("ERROR: game_manager singleton not found!")

func _on_enter(body):
	print("Body entered flag area: ", body)
	if body is Player:
		print("Player entered flag area")
		emit_signal("player_enter", body, self)

func _on_exit(body):
	print("Body exited flag area: ", body)
	if body is Player:
		print("Player exited flag area")
		emit_signal("player_exit", body, self)
