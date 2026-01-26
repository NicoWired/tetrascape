class_name Player
extends CharacterBody2D

enum States {
	IDLE,
	RUNNING,
	WALL,
	JUMPING
}

# movement constants
const ACCELERATION: float = 1000.0
const MAX_SPEED: float = 350.0
const MAX_JUMP_VELOCITY = -450.0
const WALL_JUMP_X: float = 350.0
const WALL_FRICTION: float = 0.3

const BASE_SIZE: int = 64
const SCALE_SIZE: float = float(GameConfig.TILE_SIZE) / BASE_SIZE

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

@onready var player_animation: AnimatedSprite2D = $PlayerAnimation


func _ready() -> void:
	scale = Vector2(SCALE_SIZE, SCALE_SIZE)
	GlobalStates.toggled_changed.connect(on_toggle_changed)
	initialize()

func _physics_process(delta: float) -> void:
	if GlobalStates.toggle:
		return

	# apply grvity
	if state == States.WALL and velocity.y > 0:
		velocity += get_gravity() * delta * WALL_FRICTION
	else:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = MAX_JUMP_VELOCITY
		if is_on_wall_only():
			velocity.y = MAX_JUMP_VELOCITY
			velocity.x = WALL_JUMP_X * get_wall_normal().x

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x += direction * ACCELERATION * delta
		velocity.x = clamp(velocity.x, MAX_SPEED * -1, MAX_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
	
	move_and_slide()
	
	# set state at th end of the frame
	if is_on_floor():
		if velocity.x == 0:
			state = States.IDLE
		else:
			state = States.RUNNING
	elif is_on_wall_only():
		state = States.WALL
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
	if not GlobalStates.toggle and player_animation.is_playing():
		player_animation.pause()
	else:
		player_animation.play()
