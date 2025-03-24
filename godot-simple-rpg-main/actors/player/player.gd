class_name Player
extends Actor

@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : StateMachine = $StateMachine
@onready var tilemap: TileMap = get_parent().find_child("TileMap")  # Finds the TileMap in the scene
@onready var message_label: Label = get_tree().get_first_node_in_group("message_ui")  # Finds the message UI Label

var afraid_of_water = true  # If true, player will not enter water

func _ready() -> void:
	anim_tree.active = true
	animation_state_ready.connect(_on_animation_state_ready) # Connect the signal from the Actor class to _on_animation_state_ready()

func _on_animation_state_ready():
	state_machine.change_state("Idle", {"actor": self}) #Now initialize the state machine to Idle safely.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		state_machine.change_state("Attack", {"actor": self})

func get_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta: float) -> void:
	if is_alive:
		var direction = get_direction()
		velocity = direction * 100  # Adjust speed as needed
		move_and_slide()

		# Check if player is touching water
		if afraid_of_water and is_touching_water():
			show_message("I'm too afraid to go into the water right now...")
			velocity = Vector2.ZERO  # Stop movement when touching water
			move_and_slide()  # Apply stop immediately

func is_touching_water() -> bool:
	if not tilemap:
		return false
	var tile_pos = tilemap.local_to_map(global_position)
	var tile_data = tilemap.get_cell_tile_data(1, tile_pos)  # Adjust layer if necessary
	if tile_data == null:
		return false

	# Check if the tile has a specific terrain tag or custom data
	return tile_data.get_custom_data("is_water") == true  # Set this in the TileSet editor


func show_message(text: String):
	if message_label:
		message_label.text = text
		message_label.visible = true
		get_tree().create_timer(2.0).timeout.connect(hide_message)  # Hide after 2 sec

func hide_message():
	if message_label:
		message_label.visible = false

func _on_health_health_depleted() -> void:
	is_alive = false
	anim_tree.active = false
	anim_player.play("death")
	await anim_player.animation_finished
	queue_free()
