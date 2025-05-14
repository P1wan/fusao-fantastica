# Player.gd – Tonico empurra / puxa blocos (modo Kinematic durante grab)
# ----------------------------------------------------------------------------
# Controles
#   •  ← →  (A‑D)   → mover
#   •  push          → agarrar / soltar bloco (Tonico)
#   •  ui_accept     → pular  ‑ (Tonico solta e pula)
#   •  swap_next/prev→ trocar personagem
# ----------------------------------------------------------------------------
extends CharacterBody2D
class_name Player

# Enum ------------------------------------------------------------------------
enum Character { RAFA, BIA, TONICO }

# Movimento --------------------------------------------------------------------
@export var gravity      : float = 900.0
@export var acceleration : float = 1800.0

const STATS := {
	Character.RAFA  : { "speed": 260.0, "jump_v": -380.0 },
	Character.BIA   : { "speed": 220.0, "jump_v": -460.0 },
	Character.TONICO: { "speed": 160.0, "jump_v": -300.0 },
}

@onready var shape_map := {
	Character.RAFA  : $ShapeRafa,
	Character.BIA   : $ShapeBia,
	Character.TONICO: $ShapeTonico,
}

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Push params ------------------------------------------------------------------
@export var tonico_push_speed   : float = 50.0   # vel. máx. segurando
@export var grab_range          : float = 18.0   # busca parado
@export var push_buffer         : float = 8.0    # distance buffer when pushing

# Estado -----------------------------------------------------------------------
var current : Character = Character.RAFA :
	set(v):
		current = v
		_apply_shape()
		_apply_stats()
		_apply_idle_anim()
		_release_block()

var grabbing_block: RigidBody2D = null
var grab_offset    : Vector2 = Vector2.ZERO  # Store both X and Y offset
var saved_mask    : int   = 0

# Animation state tracking
var last_direction := 1  # 1 for right, -1 for left
var was_on_floor := true  # Track previous frame's floor state
var is_landing := false  # Track if currently playing landing animation

# Ready ------------------------------------------------------------------------
func _ready():
	_apply_shape()
	_apply_stats()
	_apply_idle_anim()

# Utilitários ------------------------------------------------------------------
func _apply_shape():
	for ch in shape_map.keys():
		(shape_map[ch] as CollisionShape2D).disabled = (ch != current)

func _apply_stats():
	velocity.y = clamp(velocity.y, STATS[current]["jump_v"], INF)

func _apply_idle_anim():
	animated_sprite.play("idle_" + ["rafa", "bia", "tonico"][current])
	_update_sprite_direction()

# -----------------------------------------------------------------------------
func _physics_process(delta):
	var dir_input := Input.get_axis("ui_left", "ui_right")
	var max_speed = tonico_push_speed if (grabbing_block and current == Character.TONICO) else STATS[current]["speed"]
	velocity.x = move_toward(velocity.x, dir_input * max_speed, acceleration * delta)

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if grabbing_block and current == Character.TONICO:
			_release_block()
		velocity.y = STATS[current]["jump_v"]

	# Gravidade
	velocity.y += gravity * delta
	move_and_slide()

	# Update animations after movement
	_update_animations()

	# Grab logic --------------------------------------------------------------
	if current == Character.TONICO:
		if grabbing_block:
			_process_grabbed_block()
		elif Input.is_action_just_pressed("push"):
			_try_start_grab()

	# Swap personagem ---------------------------------------------------------
	if Input.is_action_just_pressed("swap_next"):
		current = ((current + 1) % 3) as Character
	elif Input.is_action_just_pressed("swap_prev"):
		current = ((current + 2) % 3) as Character

# Animation handling ----------------------------------------------------------
func _update_animations():
	var char_names = ["rafa", "bia", "tonico"]
	var char_name = char_names[current]
	var new_animation := ""
	
	# Special case: Tonico pushing/pulling
	if current == Character.TONICO and grabbing_block:
		new_animation = "push_tonico"
		is_landing = false
	# Landing: was in air and just landed
	elif not was_on_floor and is_on_floor() and velocity.y >= 0:
		new_animation = "land_" + char_name
		is_landing = true
	# Continue landing animation until it finishes
	elif is_landing and is_on_floor():
		# Check if landing animation is still playing
		if animated_sprite.animation.begins_with("land_") and animated_sprite.is_playing():
			# Keep current landing animation
			new_animation = animated_sprite.animation
		else:
			# Landing animation finished, can proceed to other states
			is_landing = false
			new_animation = ""  # Will be determined below
	
	# Only change animation if not in middle of landing
	if not is_landing or new_animation == "":
		# In air (jumping or falling): play jump animation
		if not is_on_floor():
			new_animation = "jump_" + char_name
		# Running: moving horizontally on ground
		elif abs(velocity.x) > 10 and is_on_floor():
			new_animation = "run_" + char_name
		# Idle: on ground and not moving much
		else:
			new_animation = "idle_" + char_name
	
	# Update direction tracking
	_update_direction_tracking()
	
	# Play animation if it changed
	if animated_sprite.animation != new_animation:
		animated_sprite.play(new_animation)
	
	# Update sprite direction
	_update_sprite_direction()
	
	# Update floor tracking for next frame
	was_on_floor = is_on_floor()

func _update_direction_tracking():
	# Special case: Tonico pushing/pulling faces the block
	if current == Character.TONICO and grabbing_block:
		last_direction = 1 if grab_offset.x > 0 else -1
	# Normal case: face movement direction
	elif abs(velocity.x) > 10:
		last_direction = 1 if velocity.x > 0 else -1
	# If not moving, keep last direction

func _update_sprite_direction():
	animated_sprite.flip_h = last_direction < 0

# -----------------------------------------------------------------------------
func _try_start_grab():
	# Verifica colisões de slide primeiro
	for i in range(get_slide_collision_count()):
		var rb := get_slide_collision(i).get_collider() as RigidBody2D
		if rb and rb.is_in_group("pushable"):
			# Check if collision is not from above
			var collision_normal = get_slide_collision(i).get_normal()
			if collision_normal.y >= -0.7:  # Prevent grabbing from above (normal pointing up)
				continue
			_begin_grab(rb)
			return
	
	# Rays to check nearby blocks (left, right, only)
	var space := get_world_2d().direct_space_state
	var check_directions = [
		Vector2.LEFT * grab_range,
		Vector2.RIGHT * grab_range
	]
	
	for direction in check_directions:
		var p := PhysicsRayQueryParameters2D.create(global_position, global_position + direction)
		p.exclude = [self]
		var res := space.intersect_ray(p)
		if res and res.collider is RigidBody2D and res.collider.is_in_group("pushable"):
			_begin_grab(res.collider)
			return

func _begin_grab(rb: RigidBody2D):
	grabbing_block = rb
	grab_offset    = rb.global_position - global_position  # Store full Vector2 offset
	saved_mask     = rb.collision_mask
	rb.collision_mask &= ~1                # ignora colisão com player

# -----------------------------------------------------------------------------
func _process_grabbed_block():
	if Input.is_action_just_pressed("push"):
		_release_block()
		return
	if not is_instance_valid(grabbing_block):
		_release_block()
		return

	# Calculate target X position only (let gravity handle Y)
	var target_x = global_position.x + grab_offset.x
	
	# Check if pushing (moving in same direction as offset) and apply buffer
	var dir_input = Input.get_axis("ui_left", "ui_right")
	if abs(dir_input) > 0.1:  # Player is moving
		var moving_right = dir_input > 0
		var offset_right = grab_offset.x > 0
		
		# If pushing (moving towards the block), add buffer distance
		if moving_right == offset_right:
			var buffer_direction = 1 if offset_right else -1
			target_x += buffer_direction * push_buffer
	
	# Only move horizontally, let gravity handle vertical movement
	var movement = Vector2(target_x - grabbing_block.global_position.x, 0)
	
	if abs(movement.x) > 0.1:  # Only move if there's significant horizontal difference
		var collision = grabbing_block.move_and_collide(movement)
		# If collision occurred during push, stop Tonico's movement
		if collision and abs(dir_input) > 0.1:
			var moving_right = dir_input > 0
			var offset_right = grab_offset.x > 0
			if moving_right == offset_right:  # Was pushing
				velocity.x = 0  # Stop Tonico
		
		# Update grab_offset Y to current relative position (so it doesn't jump when grabbed again)
		grab_offset.y = grabbing_block.global_position.y - global_position.y

# -----------------------------------------------------------------------------
func _release_block():
	if grabbing_block:
		grabbing_block.collision_mask = saved_mask
	grabbing_block = null
