class_name Actor
extends CharacterBody2D

# Animation
@export var anim_player : AnimationPlayer
@export var anim_tree : AnimationTree

var anim_state : AnimationNodeStateMachinePlayback

signal animation_state_ready  # Define a signal

var is_alive : bool = true

func _ready():
	if anim_tree != null:
		anim_state = anim_tree.get("parameters/playback")
		if anim_state != null:
			animation_state_ready.emit()  # Emit the signal when ready
		else:
			printerr("Error: 'parameters/playback' not found in AnimationTree!")
	else:
		printerr("Error: anim_tree is not assigned! Make sure it's set in the Inspector.")


func get_direction() -> Vector2:
	return Vector2.ZERO
