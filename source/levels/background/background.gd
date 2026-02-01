class_name Background
extends Node2D

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var texture_rect: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE,0),
		Vector2(GameConfig.BOARD_SIZE.x * GameConfig.TILE_SIZE, GameConfig.BOARD_SIZE.y  * GameConfig.TILE_SIZE),
		Vector2(0 ,GameConfig.BOARD_SIZE.y * GameConfig.TILE_SIZE)
		])
	#sprite_2d.region_rect.end = GameConfig.BOARD_SIZE * GameConfig.TILE_SIZE
	texture_rect.size = GameConfig.BOARD_SIZE * GameConfig.TILE_SIZE
