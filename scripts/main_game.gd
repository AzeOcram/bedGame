extends Node2D

@onready var ui = $UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.startProgressBar(3.0)
	ui.startTimer(100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
