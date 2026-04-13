extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	# Kör funktion när något går in i området
 


func _on_body_entered(body: Node2D) -> void:
	var target: Node = body
	
	
	if not target.has_method("enter_dead_state") and target.get_parent():
		target = target.get_parent()
		# Om funktionen saknas → testa parent istället
	
	if target.has_method("enter_dead_state"):
		target.enter_dead_state()
		# Kör "dead state" om den finns
