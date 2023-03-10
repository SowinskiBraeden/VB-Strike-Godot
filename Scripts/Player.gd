extends KinematicBody2D

const GRAVITY: float = 400.0
const JUMP_STRENGTH: int = 350
const CAN_JUMP_TIME_LIMIT: int = 1 # seconds we are not allowed to jump
const BALL_HIT_TIME_LIMIT: int = 1

var velocity: Vector2 = Vector2()

var inBumpBox: bool = false
var inSetBox: bool = false
var isJumping: bool = false

export var PlayerSpeed: int = 180
export var Smoothness: float = 0.2
var jump_allowed_timer: int = 0
var bump_allowed_timer: int = 0

onready var anim = $AnimationPlayer

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if jump_allowed_timer > 0:
		jump_allowed_timer -= delta
		
	if bump_allowed_timer > 0:
		bump_allowed_timer -= delta
	
	var direction = 0
	if Input.is_action_pressed("p1_left"):
		direction = -1
	elif Input.is_action_pressed("p1_right"):
		direction = 1

	velocity.x = lerp(velocity.x, PlayerSpeed * direction, Smoothness)
	
	if Input.is_action_just_pressed("p1_bump") and inBumpBox and is_bump_allowed():
		GlobalSignals.emit_signal("bumpBall", Vector2(310, -880))
		bump_allowed_timer = BALL_HIT_TIME_LIMIT
	if Input.is_action_just_pressed("p1_set") and inSetBox and is_bump_allowed():
		GlobalSignals.emit_signal("setBall", Vector2(135, -720))
		bump_allowed_timer = BALL_HIT_TIME_LIMIT
	if Input.is_action_just_pressed("p1_spike") and isJumping and inSetBox and is_bump_allowed():
		GlobalSignals.emit_signal("spikeBall", Vector2(400, 150))
		bump_allowed_timer = BALL_HIT_TIME_LIMIT
	
	var motion = velocity * delta
	var collision = move_and_collide(motion)

	# Are we on the ground
	if collision:

		if collision.collider.name == "Court": isJumping = false
	
		motion = velocity.slide(collision.normal)
		velocity = move_and_slide(motion)

		if Input.is_action_pressed("p1_jump") and is_jump_allowed() and collision.collider.name == "Court":
			isJumping = true
			anim.play("Jump")
			velocity.y -= JUMP_STRENGTH
			jump_allowed_timer = CAN_JUMP_TIME_LIMIT

func is_jump_allowed() -> bool:
	return (jump_allowed_timer <= 0)
	
func is_bump_allowed() -> bool:
	return (bump_allowed_timer <= 0)

func _on_BumpBox_body_entered(body):
	if body.get_name() == "Ball": inBumpBox = true

func _on_BumpBox_body_exited(body):
	if body.get_name() == "Ball": inBumpBox = false

func _on_SetBox_body_entered(body):
	if body.get_name() == "Ball": inSetBox = true

func _on_SetBox_body_exited(body):
	if body.get_name() == "Ball": inSetBox = false
