extends Control

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var color_rect_2: ColorRect = $ColorRect2

func _on_back_button_pressed() -> void:
	animation_player_2.play("TeleportBack")

func teleport():
	get_tree().change_scene_to_file("res://main_menu.tscn")
