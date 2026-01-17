extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#f loor
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
