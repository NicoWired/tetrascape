extends Node

signal toggled_changed

var toggle: bool = true:
	set(value):
		toggled_changed.emit()
		toggle = value
