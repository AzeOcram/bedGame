extends Node2D

@onready var ui = $UI
@onready var game_over_screen = $GameOver  # Add the GameOver scene as a child
var jumpscare_running := false
var elapsed_time = 0

func _ready() -> void:
	ui.startProgressBar(1.0)
	ui.startTimer(100)

func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time > 5:
		ui.decreaseProgress(2)
		elapsed_time = 0
	
	# Jumpscare check
	var jumpscare_pos = $Monsters/JumpscarePos
	for monster in get_tree().get_nodes_in_group("monsters"):
		if is_instance_valid(monster):
			if monster.global_position.distance_to(jumpscare_pos.global_position) < 1.0:
				if not jumpscare_running:
					jumpscare_running = true
					await monster.jumpscare()
					trigger_game_over()  # Game over after jumpscare!
					jumpscare_running = false
				break

func trigger_game_over():
	if game_over_screen:
		game_over_screen.show_game_over()
