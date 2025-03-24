class_name Player
extends Actor


@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : StateMachine = $StateMachine


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

<<<<<<< HEAD
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
	
	# Get the player's position in the tilemap grid
	var tile_pos = tilemap.local_to_map(global_position)
	
	# Get the tile data at that position on Physics Layer 0
	var tile_data = tilemap.get_cell_tile_data(0, tile_pos)  # 0 = Physics Layer 0
	
	# Check if there is a collision (tile_data exists)
	return tile_data != null

func show_message(text: String):
	if message_label:
		message_label.text = text
		message_label.visible = true
		get_tree().create_timer(2.0).timeout.connect(hide_message)  # Hide after 2 sec

func hide_message():
	if message_label:
		message_label.visible = false
=======
>>>>>>> parent of 90888e5 (um i did something for touching the water and it didn tbreak but didnt work)

func _on_health_health_depleted() -> void:
	is_alive = false
	# TODO How can I use anim_state here?
	anim_tree.active = false
	anim_player.play("death")
	await anim_player.animation_finished
	queue_free()
