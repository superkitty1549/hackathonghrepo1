extends State

@export var acceleration : float = 500.0
@export var max_speed : float = 80.0

var tilemap  # Will be assigned later

func enter(_msg : Dictionary = {}) -> void:
	actor.anim_state.travel("Walk")

	# Ensure actor is valid before accessing parent
	if actor and actor.get_parent():
		tilemap = actor.get_parent().find_child("TileMap")  # More flexible than get_node()

func physics_process(delta: float) -> void:
	var direction : = actor.get_direction()
	
	if direction == Vector2.ZERO:
		state_machine.change_state("Idle")
		return

	# Update AnimationTree parameters - @TODO Review it
	actor.anim_tree.set("parameters/Idle/blend_position", actor.velocity)
	actor.anim_tree.set("parameters/Walk/blend_position", actor.velocity)
	actor.anim_tree.set("parameters/Attack/blend_position", actor.velocity)
	
	# Calculate velocity
	actor.velocity = actor.velocity.move_toward(direction * max_speed, acceleration * delta)
	
	# Move the actor
	actor.move_and_slide()

	# 🔹 Check if the player is touching a water tile
	check_water_collision()

func check_water_collision():
	if not tilemap:
		return  # Skip if tilemap isn't found

	var tile_pos = tilemap.local_to_map(actor.global_position)  # Get tile position
	var tile_data = tilemap.get_cell_tile_data(0, tile_pos)  # Layer 0

	if tile_data and tile_data.get_collision_polygons_count(0) > 0:  # If tile has collision
		show_message("I'm too afraid to go into the water rn...")

func show_message(text):
	if not actor.has_node("MessageLabel"):  # Prevent multiple messages
		var label = Label.new()
		label.name = "MessageLabel"
		label.text = text
		label.add_theme_font_size_override("font_size", 20)
		label.set_anchors_preset(Control.PRESET_CENTER)
		label.modulate.a = 0  # Start invisible
		actor.add_child(label)

		# Animate text fading in and out
		var tween = get_tree().create_tween()
		tween.tween_property(label, "modulate:a", 1.0, 0.5)  # Fade in
		await get_tree().create_timer(2.0).timeout  # Wait 2 seconds
		tween.tween_property(label, "modulate:a", 0.0, 0.5)  # Fade out
		await tween.finished
		label.queue_free()
