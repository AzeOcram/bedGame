extends CharacterBody2D
#Attributes
enum Difficulty { EASY, MEDIUM, HARD }
@export var difficulty: Difficulty = Difficulty.HARD
@onready var sprite = $Sprite2D
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

func _ready():
	add_to_group("monsters")  # Make sure this is here!
	for i in positions:
		print(i)
	randomize()
	current_index = 0
	# Move the entire CharacterBody2D, not just the sprite
	global_position = positions[current_index].global_position
	jumpscare_overlay.visible = false
	start_timer()

func get_random_delay() -> float:
	match difficulty:
		Difficulty.EASY:
			return randf_range(40.0, 60.0)
		Difficulty.MEDIUM:
			return randf_range(20.0, 40.0)
		Difficulty.HARD:
			return randf_range(1.0, 5.0)
		_:
			return 40.0

func start_timer():
	timer.start(get_random_delay())

func _on_TeleportTimer_timeout():
	current_index += 1
	
	# Stop at last position
	if current_index >= positions.size():
		timer.stop()
		return
	
	global_position = positions[current_index].global_position
	start_timer()

func reset_state(): #resets position
	current_index = 0  # Reset to starting position
	global_position = positions[current_index].global_position
	start_timer() 

func jumpscare() -> void:
	# Show overlay and play sound
	jumpscare_overlay.visible = true
	jumpscare_sound.play()
	
	# Wait a moment before shaking (build tension)
	await get_tree().create_timer(0.3).timeout
	
	# Shake effect on overlay (longer and more intense)
	var original_pos = jumpscare_overlay.position
	for i in range(20):  # More shakes (was 5)
		jumpscare_overlay.position = original_pos + Vector2(randi() % 30 - 15, randi() % 30 - 15)
		await get_tree().create_timer(0.08).timeout  # Slower shake (was 0.05)
	
	# Hold the jumpscare image still for a moment
	jumpscare_overlay.position = original_pos
	await get_tree().create_timer(1.0).timeout  # Hold for 1 second
	
	# Reset overlay
	jumpscare_overlay.visible = false
	reset_state()
