extends CharacterBody3D

var direction: Vector3
var new_direction: Vector3
var StartPos: Vector3
var in_parry_zone = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func _ready() -> void:
	if StatHandler.color_blind_mode:
		animation_player_2.play("FlashColorblind")
	else:
		animation_player_2.play("Flash")
	global_transform.origin = StartPos
	new_direction = direction

func _process(delta: float) -> void:
	if StatHandler.boss_dead or StatHandler.time_up:
		queue_free()
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		if Input.is_action_just_pressed("parry"):
			if not player.parry_finished:
				if in_parry_zone:
					StatHandler.parried = true
					StatHandler.spawn_parry_bullet(StartPos, player.global_position)
					StatHandler.spawn_parry_bullet(StartPos, player.global_position + Vector3(0, 0, 1))
					StatHandler.spawn_parry_bullet(StartPos, player.global_position - Vector3(0, 0, 1))
					StatHandler.spawn_parry_bullet(StartPos, player.global_position + Vector3(1, 0, 0))
					StatHandler.parry_combo += 1
					StatHandler.score += 100 * StatHandler.parry_combo
					StatHandler.parry_combo_timer_started = false
					queue_free()
	if StatHandler.in_tutorial:
		if not player.parry_finished:
			if in_parry_zone:
				StatHandler.parried = true
				StatHandler.spawn_parry_bullet(StartPos, player.global_position)
				StatHandler.spawn_parry_bullet(StartPos, player.global_position + Vector3(0, 0, 1))
				StatHandler.spawn_parry_bullet(StartPos, player.global_position - Vector3(0, 0, 1))
				StatHandler.spawn_parry_bullet(StartPos, player.global_position + Vector3(1, 0, 0))
				queue_free()

func _physics_process(delta: float) -> void:
	velocity = new_direction
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if not body.invincible:
			body.hit = true
			animation_player.play("Shrink")

func _on_timer_timeout() -> void:
	queue_free()
