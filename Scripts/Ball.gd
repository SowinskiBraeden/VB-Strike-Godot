extends RigidBody2D

func handle_bump_ball():
	apply_central_impulse(Vector2(310, -880))

func handle_set_ball():
	apply_central_impulse(Vector2(110, -650))
