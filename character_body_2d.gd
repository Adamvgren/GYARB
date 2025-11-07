

extends CharacterBody2D

@export var SPEED := 300.0
@export var GRAVITY := 1000.0
@export var JUMP := -500.0

func _physics_process(delta: float) -> void:
	# Lägg till gravitation
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Vänster/höger rörelse
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	else:
		velocity.x = 0

	# Hoppa
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP

	move_and_slide()
