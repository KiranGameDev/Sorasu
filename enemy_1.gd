extends CharacterBody3D

@onready var timer: Timer = $Timer
@onready var enemy_death: AudioStreamPlayer = $EnemyDeath
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var timer_4: Timer = $Timer4
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer_2: Timer = $Timer2
@onready var body: Node3D = $Body

var devisibled = false
var SPEED = 15
var type: int
var bullet = preload("res://normal_bullet.tscn")
var parry_bullet = preload("res://parry_bullet.tscn")
var shot = false
var HP = 20
var invicible = true
var hit = false
var spawner: float
var times_left_shot = 3
var random_number = RandomNumberGenerator.new()
var explosion_particles = preload("res://grenade_explode_particles.tscn")

func _ready() -> void:
	timer.start()
	if type == 1:
		animation_player.play("Move1")
	if type == 2:
		animation_player.play("Move3")
	if type == 3:
		animation_player.play("Move2")
	if type == 4:
		animation_player.play("Move4")

func _process(delta: float) -> void:
	if hit:
		HP -= 10
		hit = false
	var player = get_tree().get_first_node_in_group("player")
	if player != null and times_left_shot != 0:
		look_at(player.global_position)
	if HP <= 0:
		enemy_death.play()
		visible = false
		collision_shape_3d.disabled = true
		set_process(false)

func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null and not shot:
		timer_2.start()
		timer_4.start()

func kill():
	queue_free()

func _on_enemy_death_finished() -> void:
	set_process(true)
	queue_free()

func generate_random_number(from: float, to: float, is_int: bool) -> float:
	var number = random_number.randf_range(from, to)
	if is_int:
		number = int(number)
	return number

func _on_timer_4_timeout() -> void:
	if not devisibled:
		body.visible = false
		devisibled = true
	if times_left_shot > 0:
		StatHandler.exploding_grenade_particles(global_position)
		if generate_random_number(1, 7, true) != 6:
			var instance = bullet.instantiate()
			instance.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * -0.2)) * SPEED
			instance.StartPos = global_position
			instance.visible = true
			add_child.call_deferred(instance)
		else:
			var instance = parry_bullet.instantiate()
			instance.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * -0.2)) * SPEED
			instance.StartPos = global_position
			instance.visible = true
			add_child.call_deferred(instance)
		if generate_random_number(1, 7, true) != 6:
			var instance2 = bullet.instantiate()
			instance2.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * 0.2)) * SPEED
			instance2.StartPos = global_position
			instance2.visible = true
			add_child.call_deferred(instance2)
		else:
			var instance2 = parry_bullet.instantiate()
			instance2.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * 0.2)) * SPEED
			instance2.StartPos = global_position
			instance2.visible = true
			add_child.call_deferred(instance2)
		if generate_random_number(1, 7, true) != 6:
			var instance3 = bullet.instantiate()
			instance3.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * -0.4)) * SPEED
			instance3.StartPos = global_position
			instance3.visible = true
			add_child.call_deferred(instance3)
		else:
			var instance3 = parry_bullet.instantiate()
			instance3.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * -0.4)) * SPEED
			instance3.StartPos = global_position
			instance3.visible = true
			add_child.call_deferred(instance3)
		if generate_random_number(1, 7, true) != 6:
			var instance4 = bullet.instantiate()
			instance4.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * 0.4)) * SPEED
			instance4.StartPos = global_position
			instance4.visible = true
			add_child.call_deferred(instance4)
		else:
			var instance4 = parry_bullet.instantiate()
			instance4.direction = ((global_transform.basis.z.normalized() * -1) + (global_transform.basis.x.normalized() * 0.4)) * SPEED
			instance4.StartPos = global_position
			instance4.visible = true
			add_child.call_deferred(instance4)
		times_left_shot -= 1
	else:
		shot = true
		timer_4.stop()

func _on_timer_2_timeout() -> void:
		queue_free()
