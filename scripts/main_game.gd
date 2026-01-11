extends Node2D
@onready var ui = $UI
@onready var game_over_screen = $GameOver
var jumpscare_running := false
var elapsed_time = 0

@onready var monster1 = $Monsters/Monster1
@onready var monster2 = $Monsters/Monster2
@onready var monster3 = $Monsters/Monster3
var game_ended := false

func _ready() -> void:
	ui.startProgressBar()
	ui.startTimer(100)
	
	# Connect to UI signals for win/lose conditions
	ui.progress_complete.connect(_on_progress_complete)
	ui.timer_complete.connect(_on_timer_complete)

func _process(delta: float) -> void:
	if game_ended:
		return
		
	elapsed_time += delta
	
	# Jumpscare check
	var jumpscare_pos = $Monsters/JumpscarePos
	for monster in get_tree().get_nodes_in_group("monsters"):
		if is_instance_valid(monster):
			if monster.global_position.distance_to(jumpscare_pos.global_position) < 1.0:
				if not jumpscare_running:
					jumpscare_running = true
					ui.progress_running = false
					await monster.jumpscare()
					if monster == monster1:
						trigger_losing_condition("jumpscare")
					ui.progress_running = true
					jumpscare_running = false
				break
				
func setMonsterDifficulty():
	monster1.setDifficulty(Global.difficulty)
	monster2.setDifficulty(Global.difficulty)
	monster3.setDifficulty(Global.difficulty)
	
func _on_progress_complete():
	# Progress bar reached 100 - Player WINS
	trigger_winning_condition()

func _on_timer_complete():
	# Timer reached end without winning - Player LOSES
	trigger_losing_condition("timeout")

func trigger_winning_condition():
	if game_ended:
		return
	game_ended = true
	
	if game_over_screen:
		game_over_screen.show_game_over(true)  # Pass true for win

func trigger_losing_condition(reason: String):
	if game_ended:
		return
	game_ended = true
	
	if game_over_screen:
		game_over_screen.show_game_over(false, reason)  # Pass false for loss + reason
