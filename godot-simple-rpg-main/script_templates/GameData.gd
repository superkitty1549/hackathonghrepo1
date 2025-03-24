extends Node

const SAVE_FILE = "user://slime_data.cfg"
var slime_data = {}  # Holds slime states in memory

func _ready():
	load_all_slime_data()

func save_slime_state(slime_id, texture_path, transformed):
	slime_data[slime_id] = {
		"texture": texture_path,
		"transformed": transformed
	}
	_save_to_file()

func load_slime_state(slime_id):
	return slime_data.get(slime_id, null)

func load_all_slime_data():
	var config = ConfigFile.new()
	if config.load(SAVE_FILE) == OK:
		for key in config.get_section_keys("slimes"):
			slime_data[key] = config.get_value("slimes", key)

func _save_to_file():
	var config = ConfigFile.new()
	for key in slime_data.keys():
		config.set_value("slimes", key, slime_data[key])
	config.save(SAVE_FILE)
