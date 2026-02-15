class_name Player
extends CharacterBody2D

enum States {
	IDLE,
	RUNNING,
	WALL,
	JUMPING
}

const CAMERA_ZOOM: Vector2 = Vector2(2,2)

var cfg: PlayerConfig = PlayerConfig.new()
var charging_jump: float = 0
var remaining_coyote_time: float = 0
var was_on_floor: bool = false
var state: States:
	set(value):
		match value:
			States.IDLE:
				player_animation.animation = &"idle"
			States.RUNNING:
				player_animation.animation = &"running"
			States.WALL:
				player_animation.animation = &"wall"
			States.JUMPING:
				player_animation.animation = &"jumping"
			_:
				assert(false, "invalid player state %s" % value)
		state = value
var enabled: bool = false:
	set(value):
		enabled = value
		on_toggle_changed()

@onready var player_animation: AnimatedSprite2D = $PlayerAnimation
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	scale = Vector2(cfg.values.scale_size, cfg.values.scale_size)
	camera_2d.limit_top = 0
	camera_2d.limit_left = 0
	camera_2d.limit_bottom = GameConfig.BOARD_SIZE.y * GameConfig.TILE_SIZE
	camera_2d.limit_right = GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE
	initialize()

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	
	# activate coyote time
	if was_on_floor and not is_on_floor():
		was_on_floor = false
		remaining_coyote_time = cfg.values.coyote_time

	# apply gravity
	if remaining_coyote_time <= 0:
		if state == States.WALL and velocity.y > 0:
			velocity += get_gravity() * delta * cfg.values.wall_friction
		else:
			if velocity.y > 0:
				velocity += get_gravity() * cfg.values.fall_speed_multiplier * delta
			else:
				velocity += get_gravity() * delta
	else:
		velocity.y = 0
		remaining_coyote_time = move_toward(remaining_coyote_time, 0, delta)
	
	if Input.is_action_pressed("jump") and charging_jump > 0:
		velocity.y -= cfg.values.jump_increment * delta
	
	charging_jump = move_toward(charging_jump, 0, delta)
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or remaining_coyote_time > 0:
			velocity.y = cfg.values.min_jump_velocity
			charging_jump = cfg.values.jump_charge_time
		if is_on_wall_only():
			velocity.y = cfg.values.min_jump_velocity
			velocity.x = cfg.values.wall_jump_x * get_wall_normal().x
			charging_jump = cfg.values.jump_charge_time
		was_on_floor = false
		remaining_coyote_time = 0

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x += direction * cfg.values.horizontal_acceleration * delta
		velocity.x = clamp(velocity.x, cfg.values.max_speed * -1, cfg.values.max_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, cfg.values.horizontal_deceleration * delta)
	
	move_and_slide()
	
	# set state at th end of the frame
	if is_on_floor():
		if velocity.x == 0:
			state = States.IDLE
		else:
			state = States.RUNNING
		was_on_floor = true
	elif is_on_wall_only():
		state = States.WALL
		remaining_coyote_time = 0
	else:
		state = States.JUMPING
	
	# flip animation based on direction
	if velocity.x > 0:
		player_animation.flip_h = false
	elif velocity.x < 0:
		player_animation.flip_h = true


func initialize() -> void:
	state = States.IDLE

func on_toggle_changed() -> void:
	# update animation status
	if not enabled and player_animation.is_playing():
		player_animation.pause()
	else:
		player_animation.play()
	
	# update camera zoom
	if enabled:
		camera_2d.zoom = CAMERA_ZOOM
	else:
		camera_2d.zoom = Vector2.ONE
