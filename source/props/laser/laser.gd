extends Node2D

@export var rotation_range: float = 30

@onready var laser_beam: LaserBeam = $LaserBeam

func _ready() -> void:
	laser_beam.rotation_degrees += randf_range(0, rotation_range)
