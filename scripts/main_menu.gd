# MainMenu.gd
extends Control
@onready var playButton = $playButton 

func _ready():
	pass
	
func _on_play_pressed():
	print("Play button pressed")
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")


func _on_play_button_pressed() -> void:
	print("Play button pressed")
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
	
func _on_exit_button_pressed() -> void:
	print("Exit button pressed")
	get_tree().quit()
