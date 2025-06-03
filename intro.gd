extends Node3D

@onready var color_rect_2: ColorRect = $ColorRect2
@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	StatHandler.lives = StatHandler.max_lives
	StatHandler.continues = StatHandler.max_continues
	color_rect_2.visible = false
	StatHandler.kill_player = false
	StatHandler.score = 0
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_viewport().get_viewport_rid(), StatHandler.get_msaa_quality(StatHandler.quality))

func teleport():
	if StatHandler.level_to == 1:
		get_tree().change_scene_to_file("res://level.tscn")
	if StatHandler.level_to == 2:
		get_tree().change_scene_to_file("res://level_2.tscn")
	if StatHandler.level_to == 3:
		get_tree().change_scene_to_file("res://level_3.tscn")
	if StatHandler.level_to == 4:
		get_tree().change_scene_to_file("res://level_4.tscn")
	if StatHandler.level_to == 5:
		pass
	if StatHandler.level_to == 6:
		pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		color_rect_2.visible = true
	if color_rect_2.visible:
		teleport()
