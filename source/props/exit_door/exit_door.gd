class_name ExitDoor
extends AnimatedSprite2D

signal player_entered

var active: bool = false:
	set(value):
		active = value
		if value:
			play()

@onready var door_area: Area2D = $DoorArea

func _ready() -> void:
	scale = Vector2(GameConfig.TILE_SIZE / get_rect().end.x, GameConfig.TILE_SIZE / get_rect().end.x)
	
	door_area.body_entered.connect(check_player_entered)

func check_player_entered(_body) -> void:
	if active:
		player_entered.emit()

func get_rect() -> Rect2:
	var frame1: Texture2D = sprite_frames.get_frame_texture("open", 1)
	return Rect2(Vector2.ZERO, frame1.get_size())
