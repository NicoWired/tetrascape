class_name Background
extends Node2D

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	polygon_2d.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE,0),
		Vector2(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE, GameConfig.BOARD_SIZE.y  * GameConfig.TILE_SIZE),
		Vector2(0 ,GameConfig.BOARD_SIZE.y * GameConfig.TILE_SIZE)
		])
	texture_rect.custom_minimum_size = GameConfig.BOARD_SIZE as Vector2 * GameConfig.TILE_SIZE * (Vector2.ONE / texture_rect.scale)
