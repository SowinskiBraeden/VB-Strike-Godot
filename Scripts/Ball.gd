extends RigidBody2D

func handle_bump_ball():
	print('bump')
	apply_central_impulse(Vector2(380, -880))
