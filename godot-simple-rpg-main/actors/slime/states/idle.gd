extends State

@export var friction : float = 500.0


func enter(_msg : Dictionary = {}):
	actor = _msg.get("actor")
	if actor == null:
		printerr("Error: Actor not passed into Idle state")
		return

	actor.velocity = Vector2.ZERO
	if actor.anim_state != null:
		actor.anim_state.travel("Idle")
	else:
		printerr("Error: actor.anim_state is null in Idle state!")

func physics_process(delta: float) -> void:
	var direction : = actor.get_direction()
	if direction != Vector2.ZERO:
		state_machine.change_state("Walk")
		return

	actor.velocity = actor.velocity.move_toward(Vector2.ZERO, friction * delta)
