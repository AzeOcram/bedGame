extends Node2D

# Track monsters in each area
var monsters_in_blanket = []
var monsters_in_right = []
var monsters_in_left = []

func _ready() -> void:
	$BlanketArea.body_entered.connect(_on_blanket_body_entered)
	$BlanketArea.body_exited.connect(_on_blanket_body_exited)
	
	$RightArea.body_entered.connect(_on_right_body_entered)
	$RightArea.body_exited.connect(_on_right_body_exited)
	
	$LeftArea.body_entered.connect(_on_left_body_entered)
	$LeftArea.body_exited.connect(_on_left_body_exited)

func _on_blanket_body_entered(body):
	if body.is_in_group("monsters"):
		monsters_in_blanket.append(body)
		print(body.name + " ADDED to blanket array")

func _on_blanket_body_exited(body):
	if body.is_in_group("monsters"):
		monsters_in_blanket.erase(body)

func _on_right_body_entered(body):
	if body.is_in_group("monsters"):
		monsters_in_right.append(body)
		print(body.name + " entered right")

func _on_right_body_exited(body):
	if body.is_in_group("monsters"):
		monsters_in_right.erase(body)

func _on_left_body_entered(body):
	if body.is_in_group("monsters"):
		monsters_in_left.append(body)
		print(body.name + " entered left")

func _on_left_body_exited(body):
	if body.is_in_group("monsters"):
		monsters_in_left.erase(body)

# When clicking areas, reset monsters in that area
func _on_blanket_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("=== BLANKET CLICKED ===")
		print("Monsters in blanket array: ", monsters_in_blanket.size())
		for m in monsters_in_blanket:
			print("  - ", m.name)
		print("Monsters in right array: ", monsters_in_right.size())
		for m in monsters_in_right:
			print("  - ", m.name)
		print("Monsters in left array: ", monsters_in_left.size())
		for m in monsters_in_left:
			print("  - ", m.name)
		
		for monster in monsters_in_blanket:
			monster.reset_state()

func _on_right_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("=== RIGHT CLICKED ===")
		print("Monsters in right array: ", monsters_in_right.size())
		for m in monsters_in_right:
			print("  - ", m.name)
		
		for monster in monsters_in_right:
			monster.reset_state()

func _on_left_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Clicked Left - Resetting monsters")
		for monster in monsters_in_left:
			monster.reset_state()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == Key.KEY_Q:
			print("Q pressed")
		elif event.keycode == Key.KEY_W:
			print("W pressed")
		elif event.keycode == Key.KEY_E:
			print("E pressed")
