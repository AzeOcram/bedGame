extends Control

func _on_easy_pressed() -> void:
	Global.difficulty = Global.Difficulty.EASY
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_medium_pressed() -> void:
	Global.difficulty = Global.Difficulty.MEDIUM
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
	
func _on_hard_pressed() -> void:
	Global.difficulty = Global.Difficulty.HARD
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
