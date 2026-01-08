extends Node2D

var monsters_in_blanket := []
var monsters_in_right := []
var monsters_in_left := []

@onready var player_sprite: Sprite2D = $Player
var textures := [
	preload("res://assets/art/Player/player_look_down_full.png"),
	preload("res://assets/art/Player/player_look_left.png"),
	preload("res://assets/art/Player/player_look_right.png")
]

var light_active := false

func _ready() -> void:
	_turn_off_all_lights()
	# Connect signals
	$BlanketArea.body_entered.connect(func(b): if b.is_in_group("monsters"): monsters_in_blanket.append(b))
	$BlanketArea.body_exited.connect(func(b): if b.is_in_group("monsters"): monsters_in_blanket.erase(b))
	$RightArea.body_entered.connect(func(b): if b.is_in_group("monsters"): monsters_in_right.append(b))
	$RightArea.body_exited.connect(func(b): if b.is_in_group("monsters"): monsters_in_right.erase(b))
	$LeftArea.body_entered.connect(func(b): if b.is_in_group("monsters"): monsters_in_left.append(b))
	$LeftArea.body_exited.connect(func(b): if b.is_in_group("monsters"): monsters_in_left.erase(b))

# Mouse Input
func _on_blanket_area_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_light_logic(event.pressed, $BlanketArea/PointLight2D, monsters_in_blanket, 0)

func _on_right_area_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_light_logic(event.pressed, $RightArea/PointLight2D, monsters_in_right, 2)

func _on_left_area_input_event(_v, event, _s):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_light_logic(event.pressed, $LeftArea/PointLight2D, monsters_in_left, 1)

# Keyboard Input
func _input(event):
	if event is InputEventKey and not event.echo:
		match event.keycode:
			Key.KEY_Q: _handle_light_logic(event.pressed, $LeftArea/PointLight2D, monsters_in_left, 1)
			Key.KEY_W: _handle_light_logic(event.pressed, $BlanketArea/PointLight2D, monsters_in_blanket, 0)
			Key.KEY_E: _handle_light_logic(event.pressed, $RightArea/PointLight2D, monsters_in_right, 2)

func _handle_light_logic(pressed: bool, light_node: PointLight2D, monster_array: Array, tex_idx: int):
	light_active = pressed
	_turn_off_all_lights() # Reset visual state
	
	var ui = get_node_or_null("../UI")
	
	if light_active:
		light_node.visible = true
		player_sprite.visible = true
		player_sprite.texture = textures[tex_idx]
		if ui: ui.set_drain_rate(true)
		
		# Wait 0.2s, then check IF the light is still active before suppressing
		await get_tree().create_timer(0.2).timeout
		if light_active: 
			for monster in monster_array:
				if is_instance_valid(monster) and monster.has_method("suppress_with_light"):
					monster.suppress_with_light()
	else:
		player_sprite.visible = false
		if ui: ui.set_drain_rate(false)
		# Safety: Release ALL monsters in the game from suppression when light is released
		get_tree().call_group("monsters", "release_from_light")

func _turn_off_all_lights():
	$BlanketArea/PointLight2D.visible = false
	$RightArea/PointLight2D.visible = false
	$LeftArea/PointLight2D.visible = false
