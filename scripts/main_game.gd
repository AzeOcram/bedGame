extends Node2D

@onready var ui = $UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.startProgressBar(3.0)
	ui.startTimer(100)
	
	# DEBUG: Check if bed and monsters exist
	await get_tree().create_timer(0.5).timeout
	print("=== SCENE CHECK ===")
	print("Bed exists: ", has_node("Bed"))
	print("Monsters exists: ", has_node("Monsters"))
	if has_node("Monsters"):
		print("Monster1 exists: ", $Monsters.has_node("Monster1"))
	
	# Check positions
	print("=== POSITIONS ===")
	print("Bed position: ", $Bed.global_position)
	print("Monster1 position: ", $Monsters/Monster1.global_position)
	print("Monster2 position: ", $Monsters/Monster2.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
