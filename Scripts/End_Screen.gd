extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_Restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
	
func _on_Main_Menu() -> void:
	get_tree().change_scene_to_file("res://StartMeny.tscn")

func _on_Exit_pressed() -> void:
	get_tree().quit()
