extends CharacterBody3D

var target_pos: Vector3
var start_pos: Vector3
var rotation_speed = 0.2
var speed = 90
var prev_pos: Vector3
var rotation_random = RandomNumberGenerator.new()
var check_pos

@onready var timer: Timer = $Timer

@export var damage = 10

func _ready() -> void:
	if StatHandler.current_boss_name != "Rokanshu":
		timer.start()
	var player = get_tree().get_first_node_in_group("player")
	prev_pos = player.global_position
	global_position = start_pos
	global_rotation.y = rotation_random.randi_range(0, 180)

func _process(delta):
	StatHandler.parry_line(prev_pos, global_position, Color.DEEP_SKY_BLUE, 20, 0.05)
	if not StatHandler.boss_ready or StatHandler.time_up:
		queue_free()
	if StatHandler.current_boss_name == "Rokanshu":
		target_pos = StatHandler.boss_position
	check_pos = target_pos
	var new_transform = global_transform.looking_at(check_pos, Vector3.UP)
	global_transform = global_transform.interpolate_with(new_transform, rotation_speed)

func _physics_process(delta):
	velocity = -global_transform.basis.z * speed
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.HP -= damage
		StatHandler.spawn_parried_bullet_hit_particle(global_position)
		body.play_hit_sound()
		queue_free()

func _on_timer_timeout() -> void:
	target_pos = StatHandler.boss_position
	rotation_speed = 0.6

func _on_timer_2_timeout() -> void:
	prev_pos = global_position
