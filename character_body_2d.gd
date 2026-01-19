extends CharacterBody2D
signal dead
@onready var anim = $AnimatedSprite2D
@onready var MAX_SPEED = 200
@onready var GRAVITY = 1250
@onready var ACC = 1250
@onready var respawn_marker = get_node("/root/Map/PlayerSpawnPos")

@export var JUMP_VELOCITY = -750
@export var KNOCKBACK_SPEED: float = 300.0




enum{IDLE, WALK, AIR, DEAD}
var state = IDLE
var want_to_jump: bool = false
var jump_buffer: float = 0.0
var is_dead = false


func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)
	if anim.sprite_frames.has_animation("DEAD"):
		anim.sprite_frames.set_animation_loop("DEAD", false)

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
	if state == DEAD:
		_DEAD_STATE(delta)
		move_and_slide()
		return
	

	var input_x = Input.get_axis("ui_left", "ui_right")

	# Uppdatera riktning
	_update_direction(input_x)

	# Kör rörelse
	_movement(delta, input_x)

	# Hoppa
	if Input.is_action_just_pressed("Jump") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY

	


	
	
	match state:
		IDLE:
			_IDLE_STATE(input_x, delta)
		WALK:
			_WALK_STATE(input_x, delta)
		AIR:
			_AIR_STATE(input_x,delta)
		
		
	move_and_slide()
	
	
func _IDLE_STATE(input_x, delta):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
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

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		_enter_air_state(true)



func _AIR_STATE(input_x, delta):
	if is_on_floor():
		if abs(velocity.x) < 5:
			_enter_idle_state()
		else:
			_enter_walk_state()

func _DEAD_STATE(delta):
	_movement(delta, 0)


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


func enter_dead_state(knockback_dir: Vector2 = Vector2.ZERO):
	if state == DEAD:
		return #

	state = DEAD
	is_dead = true
	anim.play("DEAD")

	
	if knockback_dir != Vector2.ZERO:
		velocity = knockback_dir * KNOCKBACK_SPEED
	

func _on_animation_finished():
	if state == DEAD and anim.animation == "DEAD":
		_respawn()

func _respawn():
	global_position = respawn_marker.global_position
	velocity = Vector2.ZERO
	state = IDLE
	is_dead = false
	anim.play("IDLE")

	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = false
