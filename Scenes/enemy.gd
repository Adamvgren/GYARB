extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_left: RayCast2D = $Leftray
@onready var ray_right: RayCast2D = $Rightray
@onready var turn_cooldown_timer: Timer = $TurnCooldownTimer
 
var SPEED: float = 70
var GRAVITY: float = 1200

enum { IDLE, PATROL,SPAWN }
var state = SPAWN
var can_turn: bool = true

var direction = -1   

func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)
	if anim.sprite_frames.has_animation("SPAWN"):
		anim.sprite_frames.set_animation_loop("SPAWN", false)

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	match state:
		SPAWN:
			_spawn_state()
		IDLE:
			_idle_state()
		PATROL:
			_patrol_state()
			

	move_and_slide()

func _idle_state():
	anim.play("IDLE")
	velocity.x = 0

func _patrol_state():
	anim.play("WALK")
	velocity.x = SPEED * direction
	anim.flip_h = direction < 0
	
func _spawn_state():
	velocity.x = 0
	anim.play("SPAWN")
	

func _turn_around():
	direction *= -1


func _on_turn_cooldown_timer_timeout() -> void:
	can_turn = true
	
func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var direction_to_player = global_position.direction_to(body.global_position)
		body.enter_dead_state(direction_to_player)
		
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("enter_dead_state"):
		var dir = global_position.direction_to(body.global_position)
		body.enter_dead_state(dir)
		
func _on_animation_finished():
	if state == SPAWN and anim.animation == "SPAWN":
		state = PATROL

	
