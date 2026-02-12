class_name ControlCutre
extends Window

var player_config: PlayerConfig = PlayerConfig.new()
var apply_button: Button = Button.new()
@onready var player_entry_list: VBoxContainer = $HBoxContainer/PlayerEntryList
@onready var global_entry_list: VBoxContainer = $HBoxContainer/GlobalEntryList



func _ready() -> void:
	title = "Control Cutre"
	for k in player_config.values:
		create_player_entry(k, player_config.values[k])
	create_god_mode()
	apply_button.text = "Apply"
	apply_button.pressed.connect(on_apply)
	player_entry_list.add_child(apply_button)
	size = get_contents_minimum_size()

func create_player_entry(input_text: StringName, input_value: Variant) -> void:
	if input_text != &"scale_size":
		var entry_container: HBoxContainer = HBoxContainer.new()
		var entry_label: Label = Label.new()
		var entry_line: LineEdit = LineEdit.new()
		entry_label.text = input_text
		entry_line.text = str(input_value)
		entry_line.text_changed.connect(func(x): player_config.values[input_text] = float(x))
		entry_container.add_child(entry_label)
		entry_container.add_child(entry_line)
		player_entry_list.add_child(entry_container)

func on_apply() -> void:
	for player: Player in get_tree().get_nodes_in_group("player"):
		player.cfg = player_config

func create_god_mode() -> void:
	var god_mode_button: CheckButton = CheckButton.new()
	var god_mode_label: Label = Label.new()
	god_mode_button.text = "God Mode"
	god_mode_button.toggled.connect(func(x): DevGlobals.god_mode.enabled = x)
	global_entry_list.add_child(god_mode_button)
	DevGlobals.god_mode.died.connect(func(x): god_mode_label.text = "God mode deaths: %s" % x)
	global_entry_list.add_child(god_mode_label)
	
	
