extends Node

onready var ball_manager = $Ball

func _ready() -> void:
	GlobalSignals.connect("bumpBall", ball_manager, "handle_bump_ball")
	GlobalSignals.connect("setBall", ball_manager, "handle_set_ball")

