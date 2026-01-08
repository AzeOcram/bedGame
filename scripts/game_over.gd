extends CanvasLayer

@onready var retry_button = $Retry
@onready var menu_button = $MainMenu
@onready var title_label = $Title
@onready var message_label = $Message

func _ready():
	# Hide by default
	visible = false
	# Connect buttons
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func show_game_over(won: bool = false, reason: String = ""):
	visible = true
	get_tree().paused = true
	
	# Update text based on win/loss
	if won:
		if title_label:
			title_label.text = "YOU SURVIVED!"
			# Green color for win
			title_label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0))  # Bright green
		if message_label:
			message_label.text = "You successfully slept"
			message_label.add_theme_color_override("font_color", Color(0.6, 1.0, 0.6))  # Light green
	else:
		if title_label:
			title_label.text = "GAME OVER"
			# Red color for loss
			title_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))  # Bright red
		if message_label:
			match reason:
				"jumpscare":
					message_label.text = "You were caught by the monster!"
				"timeout":
					message_label.text = "You did not sleep!"
				_:
					message_label.text = "You failed to survive the night."
			message_label.add_theme_color_override("font_color", Color(1.0, 0.6, 0.6))  # Light red

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
