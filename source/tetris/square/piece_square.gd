class_name PieceSquare
extends StaticBody2D

signal player_entered

var square_texture: Texture2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var square_sprite: Sprite2D = $SquareSprite
@onready var piece_area: Area2D = $PieceArea


static func create(input_texture: Texture2D) -> PieceSquare:
	var own_scene = preload("res://source/tetris/square/piece_square.tscn")
	return own_scene.instantiate().initialize(input_texture)

func initialize(input_texture: Texture2D) -> PieceSquare:
	square_texture = input_texture
	return self

func _ready() -> void:
	assert(square_texture != null, "You must create the scene using it's 'create(texture)' method")
	collision_shape_2d.shape.size = Vector2i(GameConfig.TILE_SIZE, GameConfig.TILE_SIZE)
	collision_shape_2d.position = Vector2(GameConfig.TILE_SIZE / 2.0, GameConfig.TILE_SIZE / 2.0)
	square_sprite.texture = square_texture
	square_sprite.scale = Vector2(GameConfig.TILE_SIZE,GameConfig.TILE_SIZE) / square_sprite.texture.get_size()
	
	var collision_shape_2d_area: CollisionShape2D = collision_shape_2d.duplicate()
	piece_area.body_entered.connect(on_body_entered)
	piece_area.add_child(collision_shape_2d_area)

func on_body_entered(body) -> void:
	if body is Player:
		player_entered.emit()
