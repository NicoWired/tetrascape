class_name Level
extends Node2D

const EXIT_DOOR_COORDS: Vector2i = Vector2i(4,2) * GameConfig.TILE_SIZE
const PLAYER_SPAWN_COORDS: Vector2i = Vector2i(4,19) * GameConfig.TILE_SIZE

@onready var exit_door: ExitDoor = $ExitDoor
@onready var player: Player = $Player
@onready var board: Board = $Board


func _ready() -> void:
	# floor
	create_boundary(
		Vector2i(0,GameConfig.BOARD_SIZE.y  * GameConfig.TILE_SIZE),
		Vector2i(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE,GameConfig.BOARD_SIZE.y * GameConfig.TILE_SIZE)
	)
	# left wall
	create_boundary(
		Vector2i(0,0),
		Vector2i(0,GameConfig.BOARD_SIZE.y * GameConfig.TILE_SIZE)
	)
	# right wall
	create_boundary(
		Vector2i(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE,0),
		Vector2i(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE,GameConfig.BOARD_SIZE.y * GameConfig.TILE_SIZE)
	)
	
	board.player_entered_piece.connect(game_over)
	exit_door.player_entered.connect(game_over)
	exit_door.global_position = EXIT_DOOR_COORDS
	initialize()
	
	_dev_tools()


func initialize() -> void:
	player.position = PLAYER_SPAWN_COORDS
	board.initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle"):
		GlobalStates.toggle = not GlobalStates.toggle

func create_boundary(start_point: Vector2i, end_point: Vector2i) -> void:
	var boundary_body: StaticBody2D = StaticBody2D.new()
	var boundary_shape: CollisionShape2D = CollisionShape2D.new()
	var boundary_segment: SegmentShape2D = SegmentShape2D.new()
	boundary_segment.a = start_point
	boundary_segment.b = end_point
	boundary_shape.shape = boundary_segment
	boundary_body.add_child(boundary_shape)
	boundary_body.set_collision_layer_value(3, true)
	boundary_body.set_collision_mask_value(1, true)
	add_child(boundary_body)

func game_over() -> void:
	call_deferred("initialize")

func _dev_tools() -> void:
	var cc: ControlCutre = preload("res://source/dev/controlcutre.tscn").instantiate()
	cc.position = Vector2i(GameConfig.TILE_SIZE * GameConfig.BOARD_SIZE.x + 16, 48)
	add_child(cc)
