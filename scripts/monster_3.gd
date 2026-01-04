extends CharacterBody2D
#Attributes
enum Difficulty { EASY, MEDIUM, HARD }
@export var difficulty: Difficulty = Difficulty.HARD
@onready var sprite = $Sprite2D
@onready var timer = $TeleportTimer
@onready var positions = [
	$"../PositionG",
	$"../PositionH",
	$"../PositionI",
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
	if current_index >= positions.size():
		current_index = 0
	# Move the entire CharacterBody2D, not just the sprite
	global_position = positions[current_index].global_position
	start_timer()

func reset_state(): #resets position 
	current_index = 0
	global_position = positions[current_index].global_position
	start_timer() 
