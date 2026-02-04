class_name Spikes
extends Node2D

signal spikes_body_entered

@onready var sprite: Sprite2D = $Sprite
@onready var spike_1: CollisionShape2D = $Sprite/Collision/Spike1
@onready var spike_2: CollisionShape2D = $Sprite/Collision/Spike2
@onready var spike_3: CollisionShape2D = $Sprite/Collision/Spike3
@onready var spike_poly_1: Polygon2D = $SpikePoly1
@onready var spike_poly_2: Polygon2D = $SpikePoly2
@onready var spike_poly_3: Polygon2D = $SpikePoly3
@onready var collision: Area2D = $Sprite/Collision


func _ready() -> void:
	sprite.texture = ExtResources.chosen_spikes_texture
	
	spike_1.shape.points = spike_poly_1.polygon
	spike_2.shape.points = spike_poly_2.polygon
	spike_3.shape.points = spike_poly_3.polygon
	
	spike_poly_1.queue_free()
	spike_poly_2.queue_free()
	spike_poly_3.queue_free()

	collision.body_entered.connect(on_body_entered)
	
func on_body_entered(body) -> void:
	if body is Player:
		spikes_body_entered.emit()

func enable(enabled: bool) -> void:
	spike_1.disabled = not enabled
	spike_2.disabled = not enabled
	spike_3.disabled = not enabled
	visible = enabled
