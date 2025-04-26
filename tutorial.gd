extends Node3D

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var color_rect_2: ColorRect = $ColorRect2

func _ready() -> void:
	StatHandler.in_tutorial = true

func _on_back_button_pressed() -> void:
	animation_player_2.play("TeleportBack")

func teleport():
	get_tree().change_scene_to_file("res://main_menu.tscn")
