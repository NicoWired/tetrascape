class_name GameHUD
extends Control

@onready var countdown_label: Label = %CountdownLabel
@onready var lines_label: Label = %LinesLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var lives_label: Label = $VBoxContainer/LivesLabel


func update_lines(lines: int) -> void:
	if lines < 0:
		lines = 0
	lines_label.text = "Lines needed: %s" % lines

func update_level(level: int) -> void:
	level_label.text = "Level %s" % level

func update_lives(lives: int) -> void:
	lives_label.text = "Lives: %s" % lives
