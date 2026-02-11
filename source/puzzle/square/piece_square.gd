class_name PieceSquare
extends StaticBody2D

signal player_entered

const MAX_FRAMES_PLAYER_INSIDE: int = 3

var square_texture: Texture2D
var frames_player_inside: int = -1
var rng = RandomNumberGenerator.new()
var is_ghost: bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var square_sprite: Sprite2D = $SquareSprite
@onready var piece_area: Area2D = $PieceArea
@onready var spikes: Node2D = $Spikes
@onready var spikes_top: Spikes = $Spikes/SpikesTop
@onready var spikes_bottom: Spikes = $Spikes/SpikesBottom
@onready var spikes_left: Spikes = $Spikes/SpikesLeft
@onready var spikes_right: Spikes = $Spikes/SpikesRight


static func create(input_texture: Texture2D, input_rand_seed:int = randi()) -> PieceSquare:
	var own_scene = preload("res://source/puzzle/square/piece_square.tscn")
	return own_scene.instantiate().initialize(input_texture, input_rand_seed)

func initialize(input_texture: Texture2D, input_rand_seed: int) -> PieceSquare:
	square_texture = input_texture
	rng.seed = input_rand_seed
	return self

func _ready() -> void:
	assert(square_texture != null, "You must create the scene using it's 'create(texture)' method")
	collision_shape_2d.shape.size = Vector2i(GameConfig.TILE_SIZE, GameConfig.TILE_SIZE)
	collision_shape_2d.position = Vector2(GameConfig.TILE_SIZE / 2.0, GameConfig.TILE_SIZE / 2.0)
	square_sprite.texture = square_texture
	square_sprite.scale = Vector2(GameConfig.TILE_SIZE,GameConfig.TILE_SIZE) / square_sprite.texture.get_size()
	spikes.scale = Vector2(GameConfig.TILE_SIZE,GameConfig.TILE_SIZE) / square_sprite.texture.get_size()
	
	var collision_shape_2d_area: CollisionShape2D = collision_shape_2d.duplicate()
	piece_area.body_entered.connect(on_body_entered)
	piece_area.add_child(collision_shape_2d_area)
	
	if is_ghost:
		piece_area.set_collision_layer_value(5, true)
		piece_area.set_collision_layer_value(2, false)
		piece_area.set_collision_mask_value(1, false)
		piece_area.set_collision_mask_value(2, false)
		piece_area.set_collision_mask_value(5, true)
		for spike in spikes.get_children():
			spike.collision.set_collision_mask_value(1, false)
			spike.collision.set_collision_mask_value(2, false)
			spike.collision.set_collision_layer_value(5, true)
			spike.collision.set_collision_layer_value(2, false)
	
	enable_spikes()
	

func _physics_process(_delta) -> void:
	# this should prevent the signal from triggering when the player overlaps for only one frame
	if frames_player_inside > 0:
		var player_found: bool = false
		for body in piece_area.get_overlapping_bodies():
			if body is Player:
				frames_player_inside -= 1
				player_found = true
				break
		if not player_found:
			frames_player_inside = -1
	elif frames_player_inside == 0:
		player_entered.emit()

func on_body_entered(body) -> void:
	if body is Player:
		frames_player_inside = MAX_FRAMES_PLAYER_INSIDE

#region spikes
func current_spikes_snapshot() -> Dictionary[StringName,bool]:
	return {
		&"top": spikes_top.visible,
		&"bot": spikes_bottom.visible,
		&"left": spikes_left.visible,
		&"right": spikes_right.visible,
	}

func rotate_spikes_cw() -> void:
	var old_spikes: Dictionary[StringName,bool] = current_spikes_snapshot()
	spikes_bottom.enable(old_spikes["right"])
	spikes_left.enable(old_spikes["bot"])
	spikes_top.enable(old_spikes["left"])
	spikes_right.enable(old_spikes["top"])

func rotate_spikes_cc() -> void:
	var old_spikes: Dictionary[StringName,bool] = current_spikes_snapshot()
	spikes_bottom.enable(old_spikes["left"])
	spikes_left.enable(old_spikes["top"])
	spikes_top.enable(old_spikes["right"])
	spikes_right.enable(old_spikes["bot"])

func enable_spikes(chance: float = 0.8) -> void:
	for spike: Spikes in spikes.get_children():
		spike.spikes_body_entered.connect(func(): player_entered.emit())
		if rng.randf() > chance:
			spike.enable(true)
#endregion
