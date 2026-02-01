class_name PlayerConfig
extends Resource

# movement constants
@export var values: Dictionary[StringName,Variant] = {
	&"vertical_acceleration": 1000,
	&"max_speed": 350,
	&"min_jump_velocity": -300,
	&"jump_charge_time": 0.5,
	&"jump_increment": 400,
	&"wall_jump_x": 350,
	&"wall_friction": 0.3,
	&"coyote_time": 0.03,
	&"base_size": 64,
}

func _init() -> void:
	update_scale()

func update_scale() -> void:
	values[&"scale_size"] = float(GameConfig.TILE_SIZE) / values[&"base_size"]
