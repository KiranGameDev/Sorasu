extends Node3D

var started = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_3d: Camera3D = $Camera3D

func _process(delta: float) -> void:
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_viewport().get_viewport_rid(), StatHandler.get_msaa_quality(StatHandler.quality))
	if StatHandler.boss_ready and not started:
		animation_player.play("Scroll")
		started = true
