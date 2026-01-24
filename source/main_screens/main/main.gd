class_name Main
extends Node


func _ready() -> void:
	var current_level: Level = preload("res://source/levels/test_level.tscn").instantiate()
	add_child(current_level)
