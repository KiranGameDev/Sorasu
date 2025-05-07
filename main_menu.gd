extends Node3D

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var v_box_container_1: VBoxContainer = $CenterContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $CenterContainer/VBoxContainer2
@onready var v_box_container_3: VBoxContainer = $CenterContainer/VBoxContainer3
@onready var level_select: VBoxContainer = $CenterContainer/LevelSelect
@onready var quality_button: OptionButton = $CenterContainer/VBoxContainer2/QualityButton
@onready var camera_3d: Camera3D = $Camera3D
@onready var color_blind_button: CheckButton = $CenterContainer/VBoxContainer2/ColorBlindButton
@onready var hi_score_label: Label = $ScoreContainer/Label
@onready var lives_button: OptionButton = $CenterContainer/VBoxContainer2/LivesButton
@onready var continues_button: OptionButton = $CenterContainer/VBoxContainer2/ContinuesButton
@onready var sfx_slider: HSlider = $CenterContainer/VBoxContainer2/SFXSlider
@onready var music_slider: HSlider = $CenterContainer/VBoxContainer2/MusicSlider
@onready var button_press: AudioStreamPlayer = $ButtonPress

func _ready() -> void:
	SaveSystem.load_data()
	StatHandler.level_to = 1
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
	AudioServer.set_bus_volume_db(2, 0)
	StatHandler.kill_player = true
	StatHandler.time_up = false
	StatHandler.parry_combo = 0

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(1, StatHandler.sfx_volume)
	AudioServer.set_bus_volume_db(2, StatHandler.music_volume)
	AudioServer.set_bus_volume_db(3, StatHandler.sfx_volume)
	AudioServer.set_bus_volume_db(4, StatHandler.sfx_volume)
	StatHandler.max_lives = 0 + lives_button.selected
	StatHandler.max_continues = 0 + continues_button.selected
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_viewport().get_viewport_rid(), StatHandler.get_msaa_quality(StatHandler.quality))
	hi_score_label.text = "High Score: " + str(int(StatHandler.hi_score))

func _on_button_pressed() -> void:
	v_box_container_2.visible = false
	v_box_container_3.visible = false
	v_box_container_1.visible = false
	level_select.visible = true

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
	button_press.play()

func _on_back_pressed() -> void:
	v_box_container_1.visible = true
	v_box_container_3.visible = false
	v_box_container_2.visible = false
	level_select.visible = false
	button_press.play()

func _on_quality_button_item_selected(index: int) -> void:
	StatHandler.quality = quality_button.selected

func _on_color_blind_button_pressed() -> void:
	StatHandler.color_blind_mode = !StatHandler.color_blind_mode

func _on_button_5_pressed() -> void:
	v_box_container_3.visible = true
	v_box_container_2.visible = false
	v_box_container_1.visible = false
	level_select.visible = false
	button_press.play()

func _on_back_button_pressed() -> void:
	v_box_container_3.visible = false
	v_box_container_2.visible = false
	v_box_container_1.visible = true
	level_select.visible = false
	button_press.play()

func _on_button_4_pressed() -> void:
	animation_player_2.play("FadeInTutorial")
	button_press.play()

func _on_sfx_slider_value_changed(value: float) -> void:
	StatHandler.sfx_volume = value
	button_press.play()

func _on_music_slider_value_changed(value: float) -> void:
	StatHandler.music_volume = value

func _on_back_to_menu_pressed() -> void:
	v_box_container_3.visible = false
	v_box_container_2.visible = false
	v_box_container_1.visible = true
	level_select.visible = false
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
