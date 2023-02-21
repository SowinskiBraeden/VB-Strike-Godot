extends KinematicBody2D

const GRAVITY: float = 400.0
const JUMP_STRENGTH: int = 350
const CAN_JUMP_TIME_LIMIT: int = 1 # seconds we are not allowed to jump

var velocity: Vector2 = Vector2()

var inBumpBox: bool = false

export var PlayerSpeed: int = 125
export var Smoothness: float = 0.2
var jump_allowed_timer: int = 0

onready var anim = $AnimationPlayer

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if jump_allowed_timer > 0:
		jump_allowed_timer -= delta
	
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1

	velocity.x = lerp(velocity.x, PlayerSpeed * direction, Smoothness)
	
	#print(inBumpBox)
	if Input.is_action_just_pressed("bump") and inBumpBox:
		GlobalSignals.emit_signal("bumpBall")
	
	var motion = velocity * delta
	var collision = move_and_collide(motion)

	# Are we on the ground
	if collision:

		motion = velocity.slide(collision.normal)
		velocity = move_and_slide(motion)

		if Input.is_action_pressed("ui_up") and is_jump_allowed() and collision.collider.name == "Court":
			anim.play("Jump")
			velocity.y -= JUMP_STRENGTH
			jump_allowed_timer = CAN_JUMP_TIME_LIMIT

func is_jump_allowed() -> bool:
	return (jump_allowed_timer <= 0)

func _on_BumpBox_body_entered(body):
	if body.get_name() == "Ball": inBumpBox = true

func _on_BumpBox_body_exited(body):
	if body.get_name() == "Ball": inBumpBox = false
