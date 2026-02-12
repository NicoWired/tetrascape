extends Node

var god_mode: GodMode

class GodMode:
	signal died
	
	var enabled: bool = false
	var total_deaths: int = 0:
		set(value):
			total_deaths = value
			died.emit(total_deaths)
	
func _ready() -> void:
	god_mode = GodMode.new()
