# MainMenu.gd
extends Control

func _ready():
	# Set up the window size
	get_viewport().size = Vector2(640, 360)
	
	# Create and configure the background
	var background = ColorRect.new()
	background.color = Color(0.2, 0.1, 0.2)  # Dark purple base
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	add_child(background)
	
	# Create a gradient overlay
	var gradient_overlay = TextureRect.new()
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(0.9, 0.4, 0.6))  # Pink top
	gradient.add_point(1.0, Color(0.2, 0.1, 0.2))  # Dark bottom
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.fill_from = Vector2(0.5, 0)
	gradient_texture.fill_to = Vector2(0.5, 1)
	gradient_overlay.texture = gradient_texture
	gradient_overlay.anchor_right = 1.0
	gradient_overlay.anchor_bottom = 1.0
	gradient_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	add_child(gradient_overlay)
	
	# Create main container
	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -150
	vbox.offset_top = -120
	vbox.offset_right = 150
	vbox.offset_bottom = 120
	vbox.add_theme_constant_override("separation", 40)
	add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "GAME TITLE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(title)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)
	
	# Play button
	var play_btn = Button.new()
	play_btn.text = "PLAY"
	play_btn.custom_minimum_size = Vector2(200, 50)
	style_button(play_btn, Color(0.7, 0.85, 0.9))
	play_btn.pressed.connect(_on_play_pressed)
	vbox.add_child(play_btn)
	
	# Bottom buttons container
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 20)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(hbox)
	
	# Settings button
	var settings_btn = Button.new()
	settings_btn.text = "SETTINGS"
	settings_btn.custom_minimum_size = Vector2(120, 50)
	style_button(settings_btn, Color(0.9, 0.9, 0.95))
	settings_btn.pressed.connect(_on_settings_pressed)
	hbox.add_child(settings_btn)
	
	# Exit button
	var exit_btn = Button.new()
	exit_btn.text = "EXIT"
	exit_btn.custom_minimum_size = Vector2(120, 50)
	style_button(exit_btn, Color(0.9, 0.9, 0.95))
	exit_btn.pressed.connect(_on_exit_pressed)
	hbox.add_child(exit_btn)

func style_button(button: Button, bg_color: Color):
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = bg_color
	style_normal.corner_radius_top_left = 4
	style_normal.corner_radius_top_right = 4
	style_normal.corner_radius_bottom_left = 4
	style_normal.corner_radius_bottom_right = 4
	
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = bg_color.lightened(0.1)
	style_hover.corner_radius_top_left = 4
	style_hover.corner_radius_top_right = 4
	style_hover.corner_radius_bottom_left = 4
	style_hover.corner_radius_bottom_right = 4
	
	var style_pressed = StyleBoxFlat.new()
	style_pressed.bg_color = bg_color.darkened(0.1)
	style_pressed.corner_radius_top_left = 4
	style_pressed.corner_radius_top_right = 4
	style_pressed.corner_radius_bottom_left = 4
	style_pressed.corner_radius_bottom_right = 4
	
	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_pressed)
	button.add_theme_color_override("font_color", Color.BLACK)
	button.add_theme_font_size_override("font_size", 20)

func _on_play_pressed():
	print("Play button pressed")
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_settings_pressed():
	print("Settings button pressed")
	# Load settings scene here
	# get_tree().change_scene_to_file("res://settings.tscn")

func _on_exit_pressed():
	print("Exit button pressed")
	get_tree().quit()
