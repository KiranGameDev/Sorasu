extends CenterContainer

var started = false
var can_unpause = true

@onready var timer: Timer = $Timer
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var animation_player: AnimationPlayer = $Menu1/AnimationPlayer
@onready var menu_1: Control = $Menu1
@onready var menu_2: Control = $Menu2
@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var sfx_volume: HSlider = $Menu2/VBoxContainer/SFXVolume
@onready var music_volume: HSlider = $Menu2/VBoxContainer/MusicVolume
@onready var back_button: Button = $Menu1/VBoxContainer/BackButton
@onready var button: Button = $Menu2/VBoxContainer/Button
@onready var fullscreen_check: CheckBox = $Menu2/VBoxContainer/FullscreenCheck
@onready var confirmation_menu: Control = $ConfirmationMenu
@onready var no: Button = $ConfirmationMenu/VBoxContainer/No
@onready var fps_button: OptionButton = $Menu2/VBoxContainer/FPSButton

func _ready() -> void:
	get_tree().paused = false
	if StatHandler.max_fps == 30:
		fps_button.selected = 0
	if StatHandler.max_fps == 60:
		fps_button.selected = 1
	if StatHandler.max_fps == 120:
		fps_button.selected = 2
	if StatHandler.max_fps == 0:
		fps_button.selected = 3
	fullscreen_check.button_pressed = StatHandler.fullscreen
	color_rect_2.color = Color.TRANSPARENT
	sfx_volume.value = AudioServer.get_bus_volume_db(1)
	music_volume.value = AudioServer.get_bus_volume_db(2)
	menu_2.visible = false
	confirmation_menu.visible = false

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if color_rect_2.color == Color.TRANSPARENT:
		color_rect_2.visible = false
	else:
		color_rect_2.visible = true
	if StatHandler.fullscreen:
		get_tree().root.mode = Window.MODE_FULLSCREEN
	else:
		get_tree().root.mode = Window.MODE_MAXIMIZED
	AudioServer.set_bus_volume_db(1, StatHandler.sfx_volume)
	AudioServer.set_bus_volume_db(2, StatHandler.music_volume)
	AudioServer.set_bus_volume_db(3, StatHandler.sfx_volume)
	AudioServer.set_bus_volume_db(4, StatHandler.sfx_volume)
	if StatHandler.sfx_volume <= -40:
		AudioServer.set_bus_mute(1, true)
		AudioServer.set_bus_mute(3, true)
		AudioServer.set_bus_mute(4, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_mute(3, false)
		AudioServer.set_bus_mute(4, false)
	if StatHandler.music_volume <= -40:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
	if get_tree().paused:
		visible = true
	else:
		visible = false
		menu_2.visible = false
		menu_1.visible = true
		confirmation_menu.visible = false
	if visible:
		if not started:
			timer.start()
			can_unpause = false
			started = true
	if player != null:
		if can_unpause and color_rect_2.color == Color.TRANSPARENT:
			if Input.is_action_just_pressed("menu"):
				get_tree().paused = !get_tree().paused
				started = !started
				visible = !visible
				menu_1.visible = true
				menu_2.visible = false
				confirmation_menu.visible = false
				if visible == true:
					back_button.grab_focus()

func _on_main_menu_button_pressed() -> void:
	menu_1.visible = false
	menu_2.visible = false
	confirmation_menu.visible = true
	no.grab_focus()
	button_pressed.play()

func teleport():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	visible = false

func _on_back_button_pressed() -> void:
	if color_rect_2.color == Color.TRANSPARENT:
		get_tree().paused = false
		started = false
		visible = false
		button_pressed.play()

func _on_timer_timeout() -> void:
	can_unpause = true

func _on_settings_button_pressed() -> void:
	menu_2.visible = true
	menu_1.visible = false
	confirmation_menu.visible = false
	button_pressed.play()
	button.grab_focus()

func _on_sfx_volume_value_changed(value: float) -> void:
	StatHandler.sfx_volume = value
	button_pressed.play()

func _on_music_volume_value_changed(value: float) -> void:
	StatHandler.music_volume = value

func _on_button_pressed() -> void:
	menu_2.visible = false
	menu_1.visible = true
	confirmation_menu.visible = false
	button_pressed.play()
	back_button.grab_focus()

func _on_fullscreen_check_pressed() -> void:
	StatHandler.fullscreen = !StatHandler.fullscreen

func _on_yes_pressed() -> void:
	animation_player.play("FadeIn")
	Engine.time_scale = 1
	button_pressed.play()

func _on_no_pressed() -> void:
	menu_2.visible = false
	menu_1.visible = true
	confirmation_menu.visible = false
	back_button.grab_focus()
	button_pressed.play()

func _on_fps_button_item_selected(index: int) -> void:
	if index == 0:
		StatHandler.max_fps = 30
		StatHandler.set_fps(StatHandler.max_fps)
		Engine.physics_ticks_per_second = 120
	if index == 1:
		StatHandler.max_fps = 60
		StatHandler.set_fps(StatHandler.max_fps)
		Engine.physics_ticks_per_second = 120
	if index == 2:
		StatHandler.max_fps = 120
		StatHandler.set_fps(StatHandler.max_fps)
		Engine.physics_ticks_per_second = 120
	if index == 3:
		StatHandler.max_fps = 0
		StatHandler.set_fps(StatHandler.max_fps)
		Engine.physics_ticks_per_second = 120
	button_pressed.play()
