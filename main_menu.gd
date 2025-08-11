extends Node3D

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var v_box_container_1: VBoxContainer = $CenterContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $CenterContainer/VBoxContainer2
@onready var v_box_container_3: VBoxContainer = $CenterContainer/VBoxContainer3
@onready var level_select: VBoxContainer = $CenterContainer/LevelSelect
@onready var quality_button: OptionButton = $CenterContainer/VBoxContainer2/QualityButton
@onready var camera_3d: Camera3D = $Camera3D
@onready var color_blind_button: CheckButton = $CenterContainer/VBoxContainer2/ColorBlindButton
@onready var lives_button: OptionButton = $CenterContainer/VBoxContainer2/LivesButton
@onready var continues_button: OptionButton = $CenterContainer/VBoxContainer2/ContinuesButton
@onready var sfx_slider: HSlider = $CenterContainer/VBoxContainer2/SFXSlider
@onready var music_slider: HSlider = $CenterContainer/VBoxContainer2/MusicSlider
@onready var button_press: AudioStreamPlayer = $ButtonPress
@onready var play_button: Button = $CenterContainer/VBoxContainer/Button
@onready var settings_back: Button = $CenterContainer/VBoxContainer2/Back
@onready var credits_back: Button = $CenterContainer/VBoxContainer3/BackButton
@onready var level_select_back: Button = $CenterContainer/LevelSelect/BackToMenu
@onready var fullscreen_check: CheckBox = $CenterContainer/VBoxContainer2/FullscreenCheck
@onready var level_1_highscore: Label = $CenterContainer/LevelSelect/Level1Highscore
@onready var level_2_highscore: Label = $CenterContainer/LevelSelect/Level2Highscore
@onready var level_3_highscore: Label = $CenterContainer/LevelSelect/Level3Highscore
@onready var level_4_highscore: Label = $CenterContainer/LevelSelect/Level4Highscore
@onready var level_5_highscore: Label = $CenterContainer/LevelSelect/Level5Highscore
@onready var level_6_highscore: Label = $CenterContainer/LevelSelect/Level6Highscore
@onready var fps_button: OptionButton = $CenterContainer/VBoxContainer2/FPSButton

func _ready() -> void:
	level_1_highscore.text = "Highscore: " + str(StatHandler.hi_score_1)
	level_2_highscore.text = "Highscore: " + str(StatHandler.hi_score_2)
	level_3_highscore.text = "Highscore: " + str(StatHandler.hi_score_3)
	level_4_highscore.text = "Highscore: " + str(StatHandler.hi_score_4)
	level_5_highscore.text = "Highscore: " + str(StatHandler.hi_score_5)
	level_6_highscore.text = "Highscore: " + str(StatHandler.hi_score_6)
	if StatHandler.max_fps == 30:
		fps_button.selected = 0
	if StatHandler.max_fps == 60:
		fps_button.selected = 1
	if StatHandler.max_fps == 120:
		fps_button.selected = 2
	if StatHandler.max_fps == 0:
		fps_button.selected = 3
	SaveSystem.load_data()
	StatHandler.level_to = 1
	fullscreen_check.button_pressed = StatHandler.fullscreen
	StatHandler.ex_mode = false
	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	music_slider.value = AudioServer.get_bus_volume_db(2)
	StatHandler.deaths = 0
	lives_button.selected = 0 + StatHandler.max_lives
	continues_button.selected = 0 + StatHandler.max_continues
	quality_button.selected = StatHandler.quality
	color_blind_button.button_pressed = StatHandler.color_blind_mode
	v_box_container_1.visible = true
	v_box_container_2.visible = false
	v_box_container_3.visible = false
	level_select.visible = false
	StatHandler.kill_player = true
	StatHandler.time_up = false
	StatHandler.parry_combo = 0
	play_button.grab_focus()

func _process(delta: float) -> void:
	StatHandler.kill_player = true

func apply_changes():
	StatHandler.set_fps(StatHandler.max_fps)
	if StatHandler.fullscreen:
		get_tree().root.mode = Window.MODE_FULLSCREEN
	else:
		get_tree().root.mode = Window.MODE_MAXIMIZED
	StatHandler.max_lives = 0 + lives_button.selected
	StatHandler.max_continues = 0 + continues_button.selected
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_viewport().get_viewport_rid(), StatHandler.get_msaa_quality(StatHandler.quality))

func _on_button_pressed() -> void:
	v_box_container_2.visible = false
	v_box_container_3.visible = false
	v_box_container_1.visible = false
	level_select.visible = true
	level_select_back.grab_focus()
	button_press.play()

func teleport():
	get_tree().change_scene_to_file("res://intro.tscn")

func teleport_tutorial():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_button_3_pressed() -> void:
	v_box_container_2.visible = true
	v_box_container_3.visible = false
	v_box_container_1.visible = false
	level_select.visible = false
	settings_back.grab_focus()
	button_press.play()

func _on_back_pressed() -> void:
	v_box_container_1.visible = true
	v_box_container_3.visible = false
	v_box_container_2.visible = false
	level_select.visible = false
	play_button.grab_focus()
	button_press.play()

func _on_quality_button_item_selected(index: int) -> void:
	StatHandler.quality = quality_button.selected
	button_press.play()

func _on_color_blind_button_pressed() -> void:
	StatHandler.color_blind_mode = !StatHandler.color_blind_mode
	button_press.play()

func _on_button_5_pressed() -> void:
	v_box_container_3.visible = true
	v_box_container_2.visible = false
	v_box_container_1.visible = false
	level_select.visible = false
	credits_back.grab_focus()
	button_press.play()

func _on_back_button_pressed() -> void:
	v_box_container_3.visible = false
	v_box_container_2.visible = false
	v_box_container_1.visible = true
	level_select.visible = false
	play_button.grab_focus()
	button_press.play()

func _on_button_4_pressed() -> void:
	animation_player_2.play("FadeInTutorial")
	button_press.play()

func _on_sfx_slider_value_changed(value: float) -> void:
	StatHandler.sfx_volume = value
	AudioServer.set_bus_volume_db(1, StatHandler.sfx_volume)
	AudioServer.set_bus_volume_db(3, StatHandler.sfx_volume)
	AudioServer.set_bus_volume_db(4, StatHandler.sfx_volume)
	button_press.play()

func _on_music_slider_value_changed(value: float) -> void:
	StatHandler.music_volume = value
	AudioServer.set_bus_volume_db(2, StatHandler.music_volume)

func _on_back_to_menu_pressed() -> void:
	v_box_container_3.visible = false
	v_box_container_2.visible = false
	v_box_container_1.visible = true
	level_select.visible = false
	play_button.grab_focus()
	button_press.play()

func _on_level_1_button_pressed() -> void:
	StatHandler.level_to = 1
	StatHandler.in_tutorial = false
	animation_player_2.play("FadeIn")
	button_press.play()

func _on_level_2_button_pressed() -> void:
	StatHandler.level_to = 2
	StatHandler.in_tutorial = false
	animation_player_2.play("FadeIn")
	button_press.play()

func _on_ex_mode_button_pressed() -> void:
	StatHandler.ex_mode = !StatHandler.ex_mode
	button_press.play()

func _on_level_3_button_pressed() -> void:
	StatHandler.level_to = 3
	StatHandler.in_tutorial = false
	animation_player_2.play("FadeIn")
	button_press.play()

func _on_level_4_button_pressed() -> void:
	StatHandler.level_to = 4
	StatHandler.in_tutorial = false
	animation_player_2.play("FadeIn")
	button_press.play()

func _on_fullscreen_check_pressed() -> void:
	StatHandler.fullscreen = !StatHandler.fullscreen
	button_press.play()

func _on_level_5_button_pressed() -> void:
	StatHandler.level_to = 5
	StatHandler.in_tutorial = false
	animation_player_2.play("FadeIn")
	button_press.play()

func _on_level_6_button_pressed() -> void:
	StatHandler.level_to = 6
	StatHandler.in_tutorial = false
	animation_player_2.play("FadeIn")
	button_press.play()

func _on_fps_button_item_selected(index: int) -> void:
	if index == 0:
		StatHandler.max_fps = 30
	if index == 1:
		StatHandler.max_fps = 60
	if index == 2:
		StatHandler.max_fps = 120
	if index == 3:
		StatHandler.max_fps = 0
	button_press.play()

func _on_apply_changes_pressed() -> void:
	apply_changes()
	button_press.play()
