extends CenterContainer

var started = false
var can_unpause = true

@onready var timer: Timer = $Timer
@onready var color_rect_2: ColorRect = $Menu1/ColorRect2
@onready var animation_player: AnimationPlayer = $Menu1/AnimationPlayer
@onready var menu_1: Control = $Menu1
@onready var menu_2: Control = $Menu2
@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var sfx_volume: HSlider = $Menu2/VBoxContainer/SFXVolume
@onready var music_volume: HSlider = $Menu2/VBoxContainer/MusicVolume

func _ready() -> void:
	color_rect_2.color = Color.TRANSPARENT
	sfx_volume.value = AudioServer.get_bus_volume_db(1)
	music_volume.value = AudioServer.get_bus_volume_db(2)
	menu_2.visible = false

func _process(delta: float) -> void:
	if color_rect_2.color == Color.TRANSPARENT:
		color_rect_2.visible = false
	else:
		color_rect_2.visible = true
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
	if visible:
		if not started:
			timer.start()
			can_unpause = false
			started = true
	if Input.is_action_just_pressed("menu") and can_unpause and color_rect_2.color == Color.TRANSPARENT:
		get_tree().paused = false
		started = false
		visible = false

func _on_main_menu_button_pressed() -> void:
	animation_player.play("FadeIn")
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
	button_pressed.play()

func _on_sfx_volume_value_changed(value: float) -> void:
	StatHandler.sfx_volume = value
	button_pressed.play()

func _on_music_volume_value_changed(value: float) -> void:
	StatHandler.music_volume = value

func _on_button_pressed() -> void:
	menu_2.visible = false
	menu_1.visible = true
	button_pressed.play()
