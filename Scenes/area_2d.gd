extends Area2D


func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_dead_state"):
		var dir = global_position.direction_to(body.global_position)
		body.enter_dead_state(dir)



func _process(delta: float) -> void:
	pass
