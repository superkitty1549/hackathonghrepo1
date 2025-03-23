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

# Keep track of assigned sprites
static var assigned_sprites = []  

# If the slime is transformed
var is_transformed = false
var player_nearby = false  # Tracks if the player is close enough to interact

func _ready():
	# Assign a unique spritesheet to each slime
	for texture in sprite_map.keys():
		if texture not in assigned_sprites:
			sprite.texture = texture
			assigned_sprites.append(texture)
			break  # Stop once we find an unused texture

func _on_health_health_depleted() -> void:
	if not is_transformed:
		is_transformed = true  # Mark as transformed
		if sprite.texture in sprite_map:
			sprite.texture = sprite_map[sprite.texture]  # Swap to normal version
	else:
		queue_free()  # If already transformed, remove it (optional)

# Detect player entering interaction zone
func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player_nearby = true

# Detect player leaving interaction zone
func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_nearby = false

# Handle interaction when pressing "E"
func _input(event):
	if event.is_action_pressed("interact") and player_nearby:
		go_to_next_level()

# Move to level2 with the player
func go_to_next_level():
	get_tree().change_scene_to_file("res://scenes/level2.tscn")
