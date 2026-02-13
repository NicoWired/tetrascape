class_name LaserBeam
extends Node2D

signal player_collision

@onready var laser_ray_cast: RayCast2D = $LaserRayCast
@onready var laser_body: Line2D = $LaserBody


func _ready() -> void:
	laser_body.add_point(Vector2.ZERO)
	laser_body.add_point(laser_body.points[0])

func _process(_delta: float) -> void:
	if laser_ray_cast.is_colliding():
		laser_body.points[1] = to_local(laser_ray_cast.get_collision_point())
		if laser_ray_cast.get_collider() is Player:
			player_collision.emit()
