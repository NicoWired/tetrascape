class_name GameHUD
extends Control

@onready var countdown_label: Label = %CountdownLabel
@onready var lines_label: Label = %LinesLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel

func update_lines(lines: int) -> void:
	if lines < 0:
		lines = 0
	lines_label.text = "Lines needed: %s" % lines

func update_level(level: int) -> void:
	level_label.text = "Level %s" % level
