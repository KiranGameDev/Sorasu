extends Node3D

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var v_box_container_1: VBoxContainer = $CenterContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $CenterContainer/VBoxContainer2
@onready var quality_button: OptionButton = $CenterContainer/VBoxContainer2/QualityButton
@onready var camera_3d: Camera3D = $Camera3D
@onready var color_blind_button: CheckButton = $CenterContainer/VBoxContainer2/ColorBlindButton
@onready var hi_score_label: Label = $ScoreContainer/Label

func _ready() -> void:
	SaveSystem.load_data()
	quality_button.selected = StatHandler.quality
	color_blind_button.button_pressed = StatHandler.color_blind_mode
	v_box_container_1.visible = true
	v_box_container_2.visible = false
	AudioServer.set_bus_volume_db(2, 0)
	StatHandler.kill_player = true
	StatHandler.time_up = false
	StatHandler.parry_combo = 0

func _process(delta: float) -> void:
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_camera_rid(), StatHandler.quality)
	hi_score_label.text = "High Score: " + str(StatHandler.hi_score)

func _on_button_pressed() -> void:
	animation_player_2.play("FadeIn")

func teleport():
	get_tree().change_scene_to_file("res://intro.tscn")

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_button_3_pressed() -> void:
	v_box_container_2.visible = true
	v_box_container_1.visible = false

func _on_back_pressed() -> void:
	v_box_container_1.visible = true
	v_box_container_2.visible = false

func _on_quality_button_item_selected(index: int) -> void:
	StatHandler.quality = quality_button.selected

func _on_color_blind_button_pressed() -> void:
	StatHandler.color_blind_mode = !StatHandler.color_blind_mode
