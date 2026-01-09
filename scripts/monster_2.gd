extends CharacterBody2D

@onready var timer = $TeleportTimer
@onready var jumpscare_sound = $AudioStreamPlayer
@onready var jumpscare_overlay = $JumpscareOverlay/Sprite2D
@onready var positions = [
	$"../PositionD", 
	$"../PositionE",
	$"../PositionF",
	$"../JumpscarePos",
]

@onready var progress_bar = $"../../UI"

var current_index := 0
var suppressed_by_light := false

func _ready():
	add_to_group("monsters")
	randomize()
	current_index = 0
	global_position = positions[current_index].global_position
	jumpscare_overlay.visible = false
	start_timer()
	print("Monster 2 difficulty is: ") 
	print(Global.difficulty)

func get_random_delay() -> float:
	match Global.difficulty:
		Global.Difficulty.EASY: return randf_range(15.0, 25.0)
		Global.Difficulty.MEDIUM: return randf_range(8.0, 15.0)
		Global.Difficulty.HARD: return randf_range(3.0, 6.0)
		_: return 15.0
	
func start_timer():
	timer.start(get_random_delay())

func _on_TeleportTimer_timeout():
	current_index += 1
	if current_index >= positions.size() - 1:
		global_position = positions[positions.size() - 1].global_position
		jumpscare()
	else:
		global_position = positions[current_index].global_position
		start_timer()

func suppress_with_light():
	suppressed_by_light = true
	timer.stop() # Stop the current movement countdown
	
	# Mechanic: Instantly retreat to the very start
	current_index = 0
	global_position = positions[0].global_position

func release_from_light():
	if suppressed_by_light:
		suppressed_by_light = false
		# RESET: They start their journey from Pos 0 with a fresh delay
		start_timer()

func reset_state(): 
	current_index = 0
	global_position = positions[current_index].global_position
	start_timer() 

func jumpscare() -> void:
	timer.stop()
	progress_bar.decreaseProgress(30)
	jumpscare_overlay.visible = true
	jumpscare_sound.play()
	await get_tree().create_timer(0.3).timeout
	var original_pos = jumpscare_overlay.position
	for i in range(20):
		jumpscare_overlay.position = original_pos + Vector2(randi() % 30 - 15, randi() % 30 - 15)
		await get_tree().create_timer(0.08).timeout
	jumpscare_overlay.position = original_pos
	await get_tree().create_timer(1.0).timeout
	jumpscare_overlay.visible = false
	reset_state()
