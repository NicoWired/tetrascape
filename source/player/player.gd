class_name Player
extends CharacterBody2D

enum States {
	IDLE,
	RUNNING,
	WALL,
	JUMPING
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

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
	GlobalStates.toggled_changed.connect(on_toggle_changed)
	initialize()

func _physics_process(delta: float) -> void:
	if GlobalStates.toggle:
		return

	# Add the gravity.
	velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
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
