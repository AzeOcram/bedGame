extends Node2D

var monsters_in_blanket := []
var monsters_in_right := []
var monsters_in_left := []

@onready var player_sprite1: Sprite2D = $PlayerDown
@onready var player_sprite2: Sprite2D = $PlayerSide
@onready var lampRight := $Lamp1
@onready var lampLeft := $Lamp2

var textures := [
	preload("res://assets/art/Player/player_look_down_full.png"),
	preload("res://assets/art/Player/player_look_left.png"),
	preload("res://assets/art/Player/player_look_right.png")
]
var bedNormal := preload("res://assets/art/environment/Bed.png")
var bedCovered := preload("res://assets/art/environment/bed_covered.png")
var light_active := false
var flashlight_working := true

func _ready() -> void:
	_turn_off_all_lights()
	$BedSprite.texture = bedCovered
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
			Key.KEY_LEFT: _handle_light_logic(event.pressed, $LeftArea/PointLight2D, monsters_in_left, 1)
			Key.KEY_DOWN: _handle_light_logic(event.pressed, $BlanketArea/PointLight2D, monsters_in_blanket, 0)
			Key.KEY_RIGHT: _handle_light_logic(event.pressed, $RightArea/PointLight2D, monsters_in_right, 2)

func _handle_light_logic(pressed: bool, light_node: PointLight2D, monster_array: Array, tex_idx: int):
	var ui = get_node_or_null("../UI")
	
	if pressed and flashlight_working:
		# Turning light ON
		light_active = true
		_turn_off_all_lights() # Reset all lights first
		light_node.visible = true
		handle_player_sprite(tex_idx)
		handle_lamp_sprite(tex_idx)
		$BedSprite.texture = bedNormal
		
		if ui: 
			ui.set_drain_rate(true)  # Slower drain when light is ON
		
		# Wait 0.2s, then check IF the light is still active before suppressing
		await get_tree().create_timer(0.2).timeout
		if light_active: 
			for monster in monster_array:
				if is_instance_valid(monster) and monster.has_method("suppress_with_light"):
					monster.suppress_with_light()
	else:
		# Turning light OFF (or flashlight broken)
		light_active = false
		_turn_off_all_lights()
		$BedSprite.texture = bedCovered
		lampLeft.texture = preload("res://assets/art/environment/Lamp_off.png")
		lampRight.texture = preload("res://assets/art/environment/Lamp_off.png")
		player_sprite1.visible = false
		player_sprite2.visible = false
		
		if ui: 
			ui.set_drain_rate(false)  # Faster drain when light is OFF
		
		# Release ALL monsters from suppression
		get_tree().call_group("monsters", "release_from_light")

func handle_player_sprite(tex_idx: int):
	if tex_idx == 0:
		$Flashlight.play()
		player_sprite1.visible = true
		player_sprite2.visible = false
		player_sprite1.texture = textures[tex_idx]
	else:
		$Lamp.play()
		player_sprite1.visible = false
		player_sprite2.visible = true
		player_sprite2.texture = textures[tex_idx]

func handle_lamp_sprite(tex_idx : int):
	if tex_idx == 1:
		lampLeft.texture = preload("res://assets/art/environment/Lamp_On.png")
	elif tex_idx == 2:
		lampRight.texture = preload("res://assets/art/environment/Lamp_On.png")

func turn_off_flashlight():
	flashlight_working = false
	await get_tree().create_timer(3).timeout
	flashlight_working = true

func _turn_off_all_lights():
	$BlanketArea/PointLight2D.visible = false
	$RightArea/PointLight2D.visible = false
	$LeftArea/PointLight2D.visible = false
