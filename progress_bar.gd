extends ProgressBar

@export var player_path: NodePath
@export var level_height_pixels: float = 20000
@export var label_path: NodePath
@export var pixels_per_meter: float = 5.2

var player: Player
var start_y: float
var best_y: float = 0 
@onready var label: Label = $MeterLabel

func _ready() -> void:
	label = get_node_or_null(label_path) as Label
	min_value = 0
	max_value = 3844
	value = 0
	

func _find_player() -> void:
	player = get_tree().get_first_node_in_group("Player") as Node2D
	if player == null:
		push_error("Hittade ingen 'player'.")
		return
	start_y = player.global_position.y



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		return
	
	
	var climed_pixels = start_y - player.global_position.y
	climed_pixels = clamp(climed_pixels, 0.0, level_height_pixels)
	
	if label:
		var meters = climed_pixels / pixels_per_meter
		label.text =str(int(meters)) + "m"
