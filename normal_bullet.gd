extends CharacterBody3D

var direction: Vector3
var new_direction: Vector3
var StartPos: Vector3
var in_parry_zone = false
var play = false
var played = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	global_transform.origin = StartPos
	new_direction = direction

func _process(delta: float) -> void:
	if StatHandler.boss_dead or StatHandler.time_up:
		queue_free()
	if StatHandler.color_blind_mode and not played:
		animation_player.play("TurnColorblind")
		played = true

func _physics_process(delta: float) -> void:
	if StatHandler.boss_dead and not play:
		animation_player.play("Shrink")
		play = true
	velocity = new_direction
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if not body.invincible:
			body.hit = true
			animation_player.play("Shrink")

func _on_timer_timeout() -> void:
	queue_free()
