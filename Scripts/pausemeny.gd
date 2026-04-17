extends Control


func resume():
	get_tree().paused = false # Startar spelet igen
	$AnimationPlayer.play_backwards("Blur") # Tar bort blur-effekten 
	
func paus():
	get_tree().paused = false 	# Pausar spelet
	$AnimationPlayer.play("Blur") 	# Lägger på blur-effekt

func testESC():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		paus() # Pausa om spelet körs
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume() # Återuppta om pausat


func _on_resume_pressed() -> void:
	resume() # Knapp för att fortsätta




func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartMeny.tscn") # Går till startmenyn


func _process(delta):
	testESC() # Kollar ESC varje frame
