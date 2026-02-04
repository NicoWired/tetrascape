class_name Spikes
extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var spike_1: CollisionShape2D = $Sprite/Collision/Spike1
@onready var spike_2: CollisionShape2D = $Sprite/Collision/Spike2
@onready var spike_3: CollisionShape2D = $Sprite/Collision/Spike3
@onready var spike_poly_1: Polygon2D = $SpikePoly1
@onready var spike_poly_2: Polygon2D = $SpikePoly2
@onready var spike_poly_3: Polygon2D = $SpikePoly3


func _ready() -> void:
	sprite.texture = ExtResources.chosen_spikes_texture
	#sprite.position = sprite.texture.get_size() / 2
	#sprite.offset = sprite.position * -1
	#scale = GameConfig.TILE_SIZE * Vector2.ONE / sprite.texture.get_size().x * Vector2.ONE
	
	spike_1.shape.points = spike_poly_1.polygon
	spike_2.shape.points = spike_poly_2.polygon
	spike_3.shape.points = spike_poly_3.polygon
	
	spike_poly_1.queue_free()
	spike_poly_2.queue_free()
	spike_poly_3.queue_free()
