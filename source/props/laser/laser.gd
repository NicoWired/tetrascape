class_name Laser
extends Node2D

@export var rotation_range: float = 30
@export var fanning_time: float = 3

var fanning_tween: Tween

@onready var laser_beam: LaserBeam = $LaserBeam

func _ready() -> void:
	fanning_tween = create_tween()
	fanning_tween.tween_property(laser_beam, "rotation_degrees", rotation_range, fanning_time)
	fanning_tween.tween_property(laser_beam, "rotation_degrees", 0, fanning_time)
	fanning_tween.set_loops()
	fanning_tween.play()
