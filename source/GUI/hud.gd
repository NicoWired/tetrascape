class_name GameHUD
extends Control

@onready var countdown_label: Label = %CountdownLabel
@onready var lines_label: Label = %LinesLabel

func update_lines(lines: int) -> void:
	if lines < 0:
		lines = 0
	lines_label.text = "Lines needed: %s" % lines
