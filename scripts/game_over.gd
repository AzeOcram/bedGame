extends CanvasLayer

@onready var retry_button = $Retry
@onready var menu_button = $MainMenu

func _ready():
	# Hide by default
	visible = false
	
	# Connect buttons
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func show_game_over():
	visible = true
	get_tree().paused = true  # Pause the game

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
