extends CharacterBody2D

@onready var timer = $TeleportTimer
@onready var jumpscare_sound = $AudioStreamPlayer
@onready var jumpscare_overlay = $JumpscareOverlay/Sprite2D
@onready var positions = [
	$"../Initial",
	$"../PositionA",
	$"../PositionB",
	$"../PositionC",
	$"../JumpscarePos",
]

var current_index := 0
var suppressed_by_light := false

func _ready():
	add_to_group("monsters")
	randomize()
	current_index = 0
	global_position = positions[current_index].global_position
	jumpscare_overlay.visible = false
	start_timer()
	print("Monster 1 difficulty is: ") 
	print(Global.difficulty)

	
func get_random_delay() -> float:
	match Global.difficulty:
		Global.Difficulty.EASY: return randf_range(10.0, 15.0)
		Global.Difficulty.MEDIUM: return randf_range(5.0, 10.0)
		Global.Difficulty.HARD: return randf_range(2.0, 5.0)
		_: return 5.0

func start_timer():
	timer.start(get_random_delay())

func _on_TeleportTimer_timeout():
	# If this triggers, it means the monster waited out its full random delay
	current_index += 1
	if current_index < positions.size():
		global_position = positions[current_index].global_position
		
		if current_index == positions.size() - 1:
			jumpscare()
		else:
			# Only start a new timer if we aren't at the jumpscare yet
			start_timer()

func suppress_with_light():
	suppressed_by_light = true
	timer.stop() # Kill the countdown immediately so it can't finish while lit

func release_from_light():
	if suppressed_by_light:
		suppressed_by_light = false
		# RESET: Start a brand new random delay from the beginning
		start_timer()

func reset_state(): 
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
		await get_tree().create_timer(0.05).timeout
	jumpscare_overlay.position = original_pos
	await get_tree().create_timer(1.0).timeout
	jumpscare_overlay.visible = false
	reset_state()
