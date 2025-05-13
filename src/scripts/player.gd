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
@export var tonico_push_speed   : float = 80.0   # vel. máx. segurando
@export var grab_range          : float = 18.0   # busca parado

# Estado -----------------------------------------------------------------------
var current : Character = Character.RAFA :
    set(v):
        current = v
        _apply_shape()
        _apply_stats()
        _apply_idle_anim()
        _release_block()

var grabbing_block: RigidBody2D = null
var grab_offset_x : float = 0.0
var saved_mask    : int   = 0
var saved_mode    : int = 0  # será definido no momento do grab

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

# -----------------------------------------------------------------------------
func _try_start_grab():
    # Verifica colisões de slide primeiro
    for i in range(get_slide_collision_count()):
        var rb := get_slide_collision(i).get_collider() as RigidBody2D
        if rb and rb.is_in_group("pushable"):
            _begin_grab(rb)
            return
    # Rays curtos esquerda/direita
    var space := get_world_2d().direct_space_state
    for off in [Vector2.LEFT, Vector2.RIGHT]:
        var p := PhysicsRayQueryParameters2D.create(global_position, global_position + off * grab_range)
        p.exclude = [self]
        var res := space.intersect_ray(p)
        if res and res.collider is RigidBody2D and res.collider.is_in_group("pushable"):
            _begin_grab(res.collider)
            return

func _begin_grab(rb: RigidBody2D):
    grabbing_block = rb
    grab_offset_x  = rb.global_position.x - global_position.x
    saved_mask     = rb.collision_mask
    saved_mode     = rb.mode
    rb.collision_mask &= ~1                # ignora colisão com player
    rb.mode = PhysicsServer2D.BODY_MODE_KINEMATIC
    rb.freeze = false

# -----------------------------------------------------------------------------
func _process_grabbed_block():
    if Input.is_action_just_pressed("push"):
        _release_block()
        return
    if not is_instance_valid(grabbing_block):
        _release_block()
        return

    # Posiciona o bloco mantendo distância X fixa
    grabbing_block.global_position.x = global_position.x + grab_offset_x

# -----------------------------------------------------------------------------
func _release_block():
    if grabbing_block:
        grabbing_block.collision_mask = saved_mask
        grabbing_block.mode = saved_mode
    grabbing_block = null
