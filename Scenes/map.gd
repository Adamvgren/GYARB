extends Node2D

const PLAYER_SCENE = preload("res://Scenes/Player.tscn")

@onready var map_music: AudioStreamPlayer2D = $MapMusic
@onready var respawn_point: Node2D = $PlayerSpawnPos
@onready var space_music: AudioStreamPlayer2D = $SpaceMusic


@export var space_y: float = -14972.5
@export var goal_y: float = -20000.0


var in_space = false
var player: Player
var finished = false
var space_grav_on = false
var orginal_grav: float = 0.0

func _ready() -> void:
	map_music.play()
	_spawn_player()
	$CanvasLayer3/Progressbarr/ProgressBar.player = player
	$CanvasLayer3/Progressbarr/ProgressBar.start_y = $PlayerSpawnPos.global_position.y



func _process(delta: float) -> void:
	if finished:
		return
	var Player = get_tree().get_first_node_in_group("Player") as Node
	
	if Player == null:
		return
		
	if Player.global_position.y <= goal_y:
		finished = true
		get_tree().paused = false
		get_tree().change_scene_to_file("res://EndScreen.tscn")
		
	if orginal_grav == 0.0:
		orginal_grav = player.GRAVITY
	
	elif not space_grav_on and player.global_position.y <= space_y:
		space_grav_on = true
		Player.GRAVITY = orginal_grav * 0.5
	
	if not in_space and player.global_position.y <= space_y:
		in_space = true
		map_music.stop()
		get_tree().paused = false
		space_music.play()
		
	elif in_space and player.global_position.y > space_y:
		in_space = false
		space_music.stop()
		map_music.play()
		
	elif space_grav_on and player.global_position.y > space_y:
		space_grav_on = false
		Player.GRAVITY = orginal_grav
func _spawn_player() -> void:
	var p = PLAYER_SCENE.instantiate()
	p.global_position = respawn_point.global_position
	
	if p.has_signal("DEAD"):
		p.connect("DEAD", _on_player_dead)
	add_child(p)
	player = p
	

func respawn_player():
	var old_player = get_node_or_null("Player")
	if old_player:
		old_player.queue_free()
	_spawn_player()

func _on_player_dead() -> void:
	respawn_player()
