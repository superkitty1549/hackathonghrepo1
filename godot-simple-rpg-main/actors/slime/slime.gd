extends Actor

@onready var sprite : Sprite2D = $Sprite2D
@onready var detection_area : DetectionArea = $DetectionArea

# Mappings for dark versions -> normal versions
var sprite_map = {
	preload("res://assets/sprites/characters/darkkami.png"): preload("res://assets/sprites/characters/kami.png"),
	preload("res://assets/sprites/characters/darknip.png"): preload("res://assets/sprites/characters/nip.png"),
	preload("res://assets/sprites/characters/darkbiscuits.png"): preload("res://assets/sprites/characters/biscuits.png"),
	preload("res://assets/sprites/characters/darkscoutf.png"): preload("res://assets/sprites/characters/scoutf.png"),
	preload("res://assets/sprites/characters/darklamber.png"): preload("res://assets/sprites/characters/lamber.png"),
}

# Static dictionary to store each slime's state across levels
static var slime_data = {}  # Stores both texture and transformation state

var is_transformed = false
var player_nearby = false  
var slime_id = ""

func _ready():
	# Create a unique ID based on position
	slime_id = str(global_position.x) + "_" + str(global_position.y)

	# Restore saved slime state if available
	if slime_id in slime_data:
		var saved_data = slime_data[slime_id]
		sprite.texture = saved_data["texture"]
		is_transformed = saved_data["transformed"]
	else:
		# Assign a random dark version if not previously assigned
		var available_textures = sprite_map.keys()  # Only dark versions
		var new_texture = available_textures[randi() % available_textures.size()]
		sprite.texture = new_texture
		slime_data[slime_id] = {"texture": new_texture, "transformed": false}

func _on_health_health_depleted() -> void:
	if not is_transformed:
		is_transformed = true  
		if sprite.texture in sprite_map:
			sprite.texture = sprite_map[sprite.texture]  # Transform to normal version
			slime_data[slime_id] = {"texture": sprite.texture, "transformed": true}  # Save state
	else:
		queue_free()  # Remove after second hit (optional)

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player_nearby = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_nearby = false

func _input(event):
	if event.is_action_pressed("interact") and player_nearby:
		go_to_next_level()

func go_to_next_level():
	get_tree().change_scene_to_file("res://scenes/level2.tscn")
