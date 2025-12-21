extends Node2D

#Attributes
enum Difficulty { EASY, MEDIUM, HARD } #Hard-Coded for now

@export var difficulty: Difficulty = Difficulty.HARD

@onready var sprite = $Sprite2D
@onready var timer = $TeleportTimer

@onready var positions = [
	$PositionA,
	$PositionB,
	$PositionC
]

var current_index := 0

func _ready():
	for i in positions:
		print(i)
	randomize()
	current_index = 0
	sprite.global_position = positions[current_index].global_position
	start_timer()

func get_random_delay() -> float:
	#Hard-Coded for now
	match difficulty:
		Difficulty.EASY:
			return randf_range(40.0, 60.0)
		Difficulty.MEDIUM:
			return randf_range(20.0, 40.0)
		Difficulty.HARD:
			return randf_range(1.0, 5.0) #for testing only
		_:
			return 40.0  # fallback value


func start_timer():
	timer.start(get_random_delay())

func _on_TeleportTimer_timeout():
	current_index += 1
	if current_index >= positions.size():
		current_index = 0   # loop back to A
	sprite.global_position = positions[current_index].global_position
	start_timer()
