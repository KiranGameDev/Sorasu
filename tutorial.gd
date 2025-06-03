extends Node3D

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var camera_3d: Camera3D = $Camera3D
@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3
@onready var back_button: Button = $BackButton

func _ready() -> void:
	back_button.grab_focus()
	StatHandler.in_tutorial = true
	if !StatHandler.color_blind_mode:
		animation_player_3.play("Tutorial")
	else:
		animation_player_3.play("TutorialColorblind")
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_viewport().get_viewport_rid(), StatHandler.get_msaa_quality(StatHandler.quality))

func _on_back_button_pressed() -> void:
	animation_player_2.play("TeleportBack")

func set_tutorial_parry(state: bool):
	StatHandler.tutorial_parry = state

func teleport():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_animation_player_3_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Tutorial":
		animation_player_2.play("TeleportBack")
	if anim_name == "TutorialColorblind":
		animation_player_2.play("TeleportBack")
