extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var MAX_SPEED = 300
@onready var GRAVITY = 1000
@onready var ACC = 1500
@export var JUMP = -500

enum{IDLE, WALK, AIR, DEAD}
var state = IDLE


func _movement(delta: float, input_x: float) -> void:
	if input_x != 0:
		velocity.x = move_toward(velocity.x, input_x * MAX_SPEED, ACC * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACC * delta)

	velocity.y += GRAVITY * delta


func _update_direction(input_x: float) -> void:
	if input_x > 0:
		sprite.flip_h = false
	elif input_x < 0:
		sprite.flip_h = true


####STATE MACHINE#########
func _physics_process(delta: float) -> void:
	var input_x = Input.get_axis("ui_left", "ui_right")

	# Uppdatera riktning
	_update_direction(input_x)

	# Kör rörelse
	_movement(delta, input_x)

	# Hoppa
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP

	move_and_slide()
	
	
	match state:
		IDLE:
			_IDLE_STATE(input_x, delta)
		WALK:
			_WALK_STATE(input_x, delta)
		AIR:
			_AIR_STATE(input_x,delta)
	move_and_slide()
	
	
func _IDLE_STATE(input_x, delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		state = AIR
	if input_x != 0:
		state = WALK
	if not is_on_floor():
		state = AIR

func _WALK_STATE(input_x, delta):
	if input_x == 0:
		state = IDLE
	if not is_on_floor():
		state = AIR
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		state = AIR

func _AIR_STATE(input_x, delta):
	if is_on_floor():
		if abs(velocity.x) < 5:
			state = IDLE
		else:
			state = WALK
