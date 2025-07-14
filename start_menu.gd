extends Node3D

@onready var center_container: CenterContainer = $CenterContainer
@onready var color_rect_4: ColorRect = $ColorRect4
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Engine.physics_ticks_per_second = StatHandler.max_fps * 2
	color_rect_4.visible = false

func _process(delta: float) -> void:
	if center_container.visible:
		if Input.is_action_just_pressed("start_menu"):
			animation_player.play("FadeIn")

func teleport():
	get_tree().change_scene_to_file("res://main_menu.tscn")
