

extends Node2D

@export var knockback_strength := 300.0

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_dead_state"):
		var dir = global_position.direction_to(body.global_position)
		body.enter_dead_state(dir * knockback_strength)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
