extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var MAX_SPEED = 100
@onready var GRAVITY = 1250
@onready var ACC = 1250
@export var JUMP_VELOCITY = -3


enum{IDLE, WALK, AIR, DEAD}
var state = IDLE
var want_to_jump: bool = false
var jump_buffer: float = 0.0


func _movement(delta: float, input_x: float) -> void:
	if input_x != 0:
		velocity.x = move_toward(velocity.x, input_x * MAX_SPEED, ACC * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACC * delta)

	velocity.y += GRAVITY * delta


func _update_direction(input_x: float) -> void:
	if input_x > 0:
		anim.flip_h = false
	elif input_x < 0:
		anim.flip_h = true


####STATE MACHINE#########
func _physics_process(delta: float) -> void:
	var input_x = Input.get_axis("ui_left", "ui_right")

	# Uppdatera riktning
	_update_direction(input_x)

	# Kör rörelse
	_movement(delta, input_x)

	# Hoppa
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY

	


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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_enter_air_state(true)

	if input_x != 0:
		_enter_walk_state()

	if not is_on_floor():
		_enter_air_state(false)


func _WALK_STATE(input_x, delta):
	if input_x == 0:
		_enter_idle_state()

	if not is_on_floor():
		_enter_air_state(false)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		_enter_air_state(true)



func _AIR_STATE(input_x, delta):
	if is_on_floor():
		if abs(velocity.x) < 5:
			_enter_idle_state()
		else:
			_enter_walk_state()



#######ENTER_STATES###########
func _enter_idle_state():
	state = IDLE
	anim.play("IDLE")

func _enter_walk_state():
	state = WALK
	anim.play("WALK")

func _enter_air_state(jumping: bool):
	state = AIR
	anim.play("AIR")

	if jumping:
		velocity.y = JUMP_VELOCITY

	
