extends RigidBody2D

var reset = false
var new_position = Vector2.ZERO

# make static and reset position
func reset(position: Vector2):
	new_position = position
	reset = true

func bump(impulse: Vector2):
	apply_central_impulse(impulse)

func _integrate_forces(state):
	if reset:
		state.transform = Transform2D(0, new_position)
		state.linear_velocity = Vector2()
		reset = false
