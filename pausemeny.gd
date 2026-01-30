extends Control


func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("Blur")
func paus():
	get_tree().paused = false
	$AnimationPlayer.play("Blur")

func testESC():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		paus()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()




func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://control.tscn")


func _process(delta):
	testESC()
