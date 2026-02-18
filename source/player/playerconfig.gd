class_name PlayerConfig
extends Resource

# movement constants
@export var values: Dictionary[StringName,float] = {
	&"horizontal_acceleration": 900,
	&"horizontal_deceleration": 1500,
	&"max_speed": 320,
	&"min_jump_velocity": -300,
	&"jump_charge_time": 0.6,
	&"jump_increment": 400,
	&"wall_jump_x": 350,
	&"wall_friction": 0.3,
	&"coyote_time": 0.04,
	&"fall_speed_multiplier": 1.2,
	&"base_size": 64,
}

func _init() -> void:
	update_scale()

func update_scale() -> void:
	values[&"scale_size"] = float(GameConfig.TILE_SIZE) / values[&"base_size"]
