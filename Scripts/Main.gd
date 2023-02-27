extends Node

onready var ball_manager = $Ball

var ball_initial_position = Vector2(160, -90)

func _ready() -> void:

	GlobalSignals.connect("bumpBall", ball_manager, "bump")

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		ball_manager.reset(ball_initial_position)
