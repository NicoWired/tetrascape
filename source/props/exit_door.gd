class_name ExitDoor
extends Sprite2D

signal player_entered

const DOOR_SHAPE_SCALE: float = 0.33

@onready var door_area: Area2D = $DoorArea
@onready var door_collision_shape: CollisionShape2D = $DoorArea/DoorCollisionShape


class DoorValues:
	signal flag_changed
	
	var flg_tl: bool:
		set(val):
			flg_tl = val
			if flg_tl:
				on_flag_changed()
	var flg_br: bool:
		set(val):
			flg_br = val
			if flg_br:
				on_flag_changed()
	
	func on_flag_changed() -> void:
		flag_changed.emit(self)


func _ready() -> void:
	var door_values = DoorValues.new()
	door_values.flag_changed.connect(check_player_entered)
	
	texture.size = Vector2(GameConfig.TILE_SIZE, GameConfig.TILE_SIZE)
	door_collision_shape.shape.size = Vector2(
		GameConfig.TILE_SIZE * DOOR_SHAPE_SCALE, GameConfig.TILE_SIZE * DOOR_SHAPE_SCALE)
	var door_area_br: Area2D = door_area.duplicate()
	
	#setup signals
	door_area.body_entered.connect(func(_x):door_values.flg_tl=true)
	door_area_br.body_entered.connect(func(_x):door_values.flg_br=true)
	door_area.body_exited.connect(func(_x):door_values.flg_tl=false)
	door_area_br.body_exited.connect(func(_x):door_values.flg_br=false)
	
	door_area_br.position = Vector2(
		GameConfig.TILE_SIZE - GameConfig.TILE_SIZE * DOOR_SHAPE_SCALE,
		(GameConfig.TILE_SIZE - GameConfig.TILE_SIZE * DOOR_SHAPE_SCALE)
		)
	var pos_offset: Vector2 = Vector2(
		GameConfig.TILE_SIZE * DOOR_SHAPE_SCALE / 2.0, GameConfig.TILE_SIZE * DOOR_SHAPE_SCALE / 2.0)
	door_area.position += pos_offset
	door_area_br.position += pos_offset
	add_child(door_area_br)

func check_player_entered(values: DoorValues) -> void:
	if values.flg_br and values.flg_tl:
		player_entered.emit()
