extends CharacterBody2D

#enum Difficulty { EASY, MEDIUM, HARD }
#@export var difficulty: Difficulty = Difficulty.HARD

@onready var timer = $TeleportTimer
@onready var jumpscare_sound = $AudioStreamPlayer
@onready var jumpscare_overlay = $JumpscareOverlay/Sprite2D
@onready var positions = [
	$"../PositionG", $"../PositionB", $"../PositionC",
	$"../PositionD", $"../PositionE", $"../PositionF",
	$"../PositionH", $"../PositionI", $"../JumpscarePos",
]

var current_index := 0
var currentTime := 0
var timeToJumpscare := 0
var suppressed_by_light := false

func _ready():
	add_to_group("monsters")
	randomize()
	current_index = 0
	global_position = positions[current_index].global_position
	jumpscare_overlay.visible = false
	timeToJumpscare = get_random_jumpscareTime()
	start_timer()
	print("Monster 3 difficulty is: ") 
	print(Global.difficulty)

	
func get_random_delay() -> float:
	match Global.difficulty:
		Global.Difficulty.EASY: return randf_range(10.0, 15.0)
		Global.Difficulty.MEDIUM: return randf_range(5.0, 10.0)
		Global.Difficulty.HARD: return randf_range(2.0, 4.0)
		_: return 10.0

func get_random_jumpscareTime() -> int:
	match Global.difficulty:
		Global.Difficulty.EASY: return randi_range(10, 14)
		Global.Difficulty.MEDIUM: return randi_range(6, 9)
		Global.Difficulty.HARD: return randi_range(3, 5)
		_: return 10

func start_timer():
	timer.start(get_random_delay())

func _on_TeleportTimer_timeout():
	currentTime += 1
	if currentTime >= timeToJumpscare:
		current_index = positions.size() - 1 
		global_position = positions[current_index].global_position
		jumpscare()
		return

	current_index = randi_range(0, positions.size() - 2)
	global_position = positions[current_index].global_position
	start_timer()

func suppress_with_light():
	if current_index == 0:
		# Behavior: Freeze at Start
		suppressed_by_light = true
		timer.stop() 
	else:
		# Behavior: Scared away to a different spot immediately
		var last_index = current_index
		while current_index == last_index:
			current_index = randi_range(0, positions.size() - 2)
		global_position = positions[current_index].global_position
		
		# RESET: New position, new delay
		start_timer()

func release_from_light():
	if suppressed_by_light:
		suppressed_by_light = false
		# RESET: Restart the delay for the first position
		start_timer()

func reset_state(): 
	currentTime = int(max(0, currentTime - 2)) 
	current_index = 0
	global_position = positions[current_index].global_position
	start_timer() 

func jumpscare() -> void:
	timer.stop()
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
