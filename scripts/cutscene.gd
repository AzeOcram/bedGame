extends Control

@onready var label: Label = $Text
@onready var type_timer: Timer = $Typing
@onready var next_timer: Timer = $Delay
@onready var end_timer: Timer = $EndTime

var lines := [
	"Well.. I guess I'm alone again",
	"It's hard to sleep without mom and dad at night.",
	"I remember a poem they always sang to me before bed.",
	"Monsters lay waste to you at night.
	Make them go away by flashing them with white.",
	"Beware, some may bite,
	Some may fright.",
	"But stay away from the dark feline light.
	One touch and you'll forever go night-night."
]

var current_line := 0
var char_index := 0

func _ready():
	label.text = ""
	type_timer.wait_time = 0.05 # typing speed
	type_timer.start()

func _on_Timer_timeout():
	if char_index < lines[current_line].length():
		label.text += lines[current_line][char_index]
		char_index += 1
	else:
		type_timer.stop()
		next_timer.start()

func _on_NextLine_timeout():
	current_line += 1
	if current_line < lines.size():
		label.text = ""
		char_index = 0
		type_timer.start()
	else:
		end_timer.start()

func _on_End_timeout():
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
