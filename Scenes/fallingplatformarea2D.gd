extends Area2D

func _ready():
 
	body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):  # Se till att spelaren är i grupp "player"
		body.die()  # kalla på spelarens dödsfunktion
