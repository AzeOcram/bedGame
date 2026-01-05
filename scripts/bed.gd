extends Node2D

# -------------------------
# Monster tracking per area
# -------------------------
var monsters_in_blanket := []
var monsters_in_right := []
var monsters_in_left := []

var blackout_running := false
@onready var monster1: CharacterBody2D = $"../Monsters/Monster1"
@onready var progress :=  $"../UI/ProgressBar"



# -------------------------
# Ready
# -------------------------
func _ready() -> void:
	# Lights OFF by default
	$BlanketArea/PointLight2D.visible = false
	$RightArea/PointLight2D.visible = false
	$LeftArea/PointLight2D.visible = false

	# Connect area signals
	$BlanketArea.body_entered.connect(_on_blanket_body_entered)
	$BlanketArea.body_exited.connect(_on_blanket_body_exited)

	$RightArea.body_entered.connect(_on_right_body_entered)
	$RightArea.body_exited.connect(_on_right_body_exited)

	$LeftArea.body_entered.connect(_on_left_body_entered)
	$LeftArea.body_exited.connect(_on_left_body_exited)

# -------------------------
# Area body tracking
# -------------------------
func _on_blanket_body_entered(body):
	if body.is_in_group("monsters"):
		monsters_in_blanket.append(body)

func _on_blanket_body_exited(body):
	if body.is_in_group("monsters"):
		monsters_in_blanket.erase(body)

func _on_right_body_entered(body):
	if body.is_in_group("monsters"):
		monsters_in_right.append(body)

func _on_right_body_exited(body):
	if body.is_in_group("monsters"):
		monsters_in_right.erase(body)

func _on_left_body_entered(body):
	if body.is_in_group("monsters"):
		monsters_in_left.append(body)

func _on_left_body_exited(body):
	if body.is_in_group("monsters"):
		monsters_in_left.erase(body)

# -------------------------
# Mouse input (hold to light)
# -------------------------
func _on_blanket_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_light(event, $BlanketArea/PointLight2D, monsters_in_blanket)

func _on_right_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_light(event, $RightArea/PointLight2D, monsters_in_right)

func _on_left_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_light(event, $LeftArea/PointLight2D, monsters_in_left)

# -------------------------
# Keyboard input (Q / W / E)
# -------------------------
func _input(event):
	if event is InputEventKey:
		match event.keycode:
			Key.KEY_Q:
				_handle_light(event, $LeftArea/PointLight2D, monsters_in_left)
			Key.KEY_W:
				_handle_light(event, $BlanketArea/PointLight2D, monsters_in_blanket)
			Key.KEY_E:
				_handle_light(event, $RightArea/PointLight2D, monsters_in_right)

# -------------------------
# Light handler (shared)
# -------------------------
func _handle_light(event, light: PointLight2D, monster_array):
	if event.pressed:
		_turn_off_all_lights()
		light.visible = true
		
		if monster_array.size() > 0 and monster_array[0] != monster1:
			$AudioStreamPlayer.play()
			await get_tree().create_timer(0.2).timeout
			light.visible = false
			
			for monster in monster_array: 
				if is_instance_valid(monster): 
					monster.reset_state()
			await get_tree().create_timer(0.3).timeout
			light.visible = true
		
	else:
		light.visible = false



# -------------------------
# Utility
# -------------------------
func _turn_off_all_lights():
	$BlanketArea/PointLight2D.visible = false
	$RightArea/PointLight2D.visible = false
	$LeftArea/PointLight2D.visible = false
