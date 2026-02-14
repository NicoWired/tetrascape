class_name Boundary
extends StaticBody2D

var start_point: Vector2
var end_point: Vector2

@onready var boundary_collision: CollisionShape2D = $BoundaryCollision

func _ready() -> void:
	var boundary_shape: SegmentShape2D = SegmentShape2D.new()
	boundary_shape.a = start_point
	boundary_shape.b = end_point
	boundary_collision.shape = boundary_shape

func set_borders(input_start_point: Vector2, input_end_point: Vector2) -> void:
	start_point = input_start_point
	end_point = input_end_point
	
