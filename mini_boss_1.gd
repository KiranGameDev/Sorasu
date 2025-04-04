extends CharacterBody3D

@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var timer_3: Timer = $Timer3
@onready var timer_4: Timer = $Timer4
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var mini_boss_1_model: Node3D = $MiniBoss1Model
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

var SPEED = 15.0
var bullet = preload("res://normal_bullet.tscn")
var parry_bullet = preload("res://parry_bullet.tscn")
var music_bus = AudioServer.get_bus_index("Music")
var explode_overlay = preload("res://explode_overlay.tscn")
var final_boom = preload("res://final_explosion.tscn")
var invicible = true
var hit = false
var spawner: float
var phase = 1
var prev_phase = 0
var times_left_shot = 5
var random_number = RandomNumberGenerator.new()
var parry_shots = 3
var parry_shots_emmitted = false
var enemy_1 = preload("res://enemy_1.tscn")

@export var HP = 1200

func _process(delta: float) -> void:
	if StatHandler.time_up:
		mini_boss_1_model.global_position.x + 0.1
	if StatHandler.boss_dead:
		AudioServer.set_bus_volume_db(music_bus, (AudioServer.get_bus_volume_db(2) - 0.1))
	if HP <= 1200 and HP > 1050:
		phase = 1
		if prev_phase != phase:
			timer.start()
			prev_phase = phase
	if HP <= 1050 and HP > 900:
		phase = 2
		if prev_phase != phase:
			timer.wait_time = 2
			ready_up()
			timer.start()
			prev_phase = phase
	if HP <= 900 and HP > 600:
		phase = 3
		if prev_phase != phase:
			timer.wait_time = 0.2
			ready_up()
			timer.start()
			timer_3.start()
			timer_2.stop()
			prev_phase = phase
	if HP <= 600 and HP > 300:
		phase = 4
		if prev_phase != phase:
			timer.wait_time = 2
			ready_up()
			timer.start()
			timer_3.stop()
			timer_2.start()
			prev_phase = phase
	if HP <= 300:
		phase = 5
		if prev_phase != phase:
			timer.wait_time = 0.2
			ready_up()
			timer.start()
			timer_3.start()
			timer_2.stop()
			prev_phase = phase
	if times_left_shot <= 0:
		ready_up()
		timer_2.stop()
		times_left_shot = 5
	StatHandler.boss_position = global_position
	if times_left_shot <= 0:
		timer_2.stop()
		times_left_shot = 5
	if hit:
		HP -= 10
		hit = false
	if phase == 3 or phase == 5:
		global_rotation.y -= 0.01
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		if phase == 1:
			look_at_target_interpolated(0.05, Vector3(0, 0, 0))
		if phase == 2:
			look_at_target_interpolated(0.05, player.global_position)
		if phase == 4:
			look_at_target_interpolated(0.05, player.global_position)
	if parry_shots == 0:
		parry_shots_emmitted = false
		parry_shots = 3
	if HP <= 0:
		kill()

func look_at_target_interpolated(weight: float, pos: Vector3) -> void:
	var xform := transform
	xform = xform.looking_at(pos, Vector3.UP)
	transform = transform.interpolate_with(xform, weight)

func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if StatHandler.boss_ready:
		if player != null:
			if phase == 1:
				var instance = bullet.instantiate()
				instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
				instance.StartPos = global_position
				add_sibling.call_deferred(instance)
				var instance2 = bullet.instantiate()
				instance2.direction = global_transform.basis.z.normalized() * -1 * SPEED
				instance2.StartPos = global_position
				add_sibling.call_deferred(instance2)
				var instance3 = bullet.instantiate()
				instance3.direction = global_transform.basis.x.normalized() * 1 * SPEED
				instance3.StartPos = global_position
				add_sibling.call_deferred(instance3)
				var instance4 = bullet.instantiate()
				instance4.direction = global_transform.basis.x.normalized() * -1 * SPEED
				instance4.StartPos = global_position
				add_sibling.call_deferred(instance4)
				var instance5 = bullet.instantiate()
				instance5.direction = ((global_transform.basis.x.normalized() * -1) + (global_transform.basis.z.normalized() * -1.4)) * (SPEED / 1.5)
				instance5.StartPos = global_position
				add_sibling.call_deferred(instance5)
				var instance6 = bullet.instantiate()
				instance6.direction = ((global_transform.basis.x.normalized() * 1) + (global_transform.basis.z.normalized() * -1.4)) * (SPEED / 1.5)
				instance6.StartPos = global_position
				add_sibling.call_deferred(instance6)
				var instance7 = bullet.instantiate()
				instance7.direction = ((global_transform.basis.x.normalized() * -1) + (global_transform.basis.z.normalized() * -0.4)) * SPEED
				instance7.StartPos = global_position
				add_sibling.call_deferred(instance7)
				var instance8 = bullet.instantiate()
				instance8.direction = ((global_transform.basis.x.normalized() * 1) + (global_transform.basis.z.normalized() * -0.4)) * SPEED
				instance8.StartPos = global_position
				add_sibling.call_deferred(instance8)
			if phase == 2:
				timer_2.start()
			if phase == 3:
				if generate_new_number(0, 9, false) <= 1:
					parry_shots_emmitted = true
				if not parry_shots_emmitted:
					var instance = bullet.instantiate()
					instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
					instance.StartPos = global_position
					add_sibling.call_deferred(instance)
					var instance2 = bullet.instantiate()
					instance2.direction = global_transform.basis.z.normalized() * 1 * SPEED
					instance2.StartPos = global_position
					add_sibling.call_deferred(instance2)
				else:
					if parry_shots > 0:
						var instance = parry_bullet.instantiate()
						instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
						instance.StartPos = global_position
						add_sibling.call_deferred(instance)
						var instance2 = parry_bullet.instantiate()
						instance2.direction = global_transform.basis.z.normalized() * 1 * SPEED
						instance2.StartPos = global_position
						add_sibling.call_deferred(instance2)
						parry_shots -= 1
			if phase == 4:
				timer_2.start()
			if phase == 5:
				if generate_new_number(0, 9, false) <= 1:
					parry_shots_emmitted = true
				if not parry_shots_emmitted:
					var instance = bullet.instantiate()
					instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
					instance.StartPos = global_position
					add_sibling.call_deferred(instance)
					var instance2 = bullet.instantiate()
					instance2.direction = global_transform.basis.z.normalized() * 1 * SPEED
					instance2.StartPos = global_position
					add_sibling.call_deferred(instance2)
					var instance3 = bullet.instantiate()
					instance3.direction = global_transform.basis.x.normalized() * -1 * SPEED
					instance3.StartPos = global_position
					add_sibling.call_deferred(instance3)
					var instance4 = bullet.instantiate()
					instance4.direction = global_transform.basis.x.normalized() * 1 * SPEED
					instance4.StartPos = global_position
					add_sibling.call_deferred(instance4)
				else:
					if parry_shots > 0:
						var instance = parry_bullet.instantiate()
						instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
						instance.StartPos = global_position
						add_sibling.call_deferred(instance)
						var instance2 = parry_bullet.instantiate()
						instance2.direction = global_transform.basis.z.normalized() * 1 * SPEED
						instance2.StartPos = global_position
						add_sibling.call_deferred(instance2)
						parry_shots -= 1
						var instance3 = parry_bullet.instantiate()
						instance3.direction = global_transform.basis.x.normalized() * -1 * SPEED
						instance3.StartPos = global_position
						add_sibling.call_deferred(instance3)
						var instance4 = parry_bullet.instantiate()
						instance4.direction = global_transform.basis.x.normalized() * 1 * SPEED
						instance4.StartPos = global_position
						add_sibling.call_deferred(instance4)

func kill():
	animation_player.play("Death")
	timer.stop()
	timer_2.stop()
	timer_3.stop()
	timer_4.stop()
	global_position.y -= 0.025
	StatHandler.boss_ready = false
	StatHandler.boss_dead = true
	StatHandler.kill_boss_timer = true

func ready_up():
	StatHandler.boss_ready = true

func _on_timer_2_timeout() -> void:
	if phase == 2:
		if times_left_shot > 0:
			var instance = bullet.instantiate()
			instance.direction = global_transform.basis.z.normalized() * -1 * (SPEED * 1.5)
			instance.StartPos = global_position
			add_sibling.call_deferred(instance)
			times_left_shot -= 1
	if phase == 4:
		if times_left_shot > 0:
			var instance = bullet.instantiate()
			instance.direction = global_transform.basis.z.normalized() * -1 * (SPEED * 1.5)
			instance.StartPos = global_position
			add_sibling.call_deferred(instance)
			var instance2 = bullet.instantiate()
			instance2.direction = (global_transform.basis.z.normalized() * -1 + global_transform.basis.x.normalized() * -0.2) * (SPEED * 1.5)
			instance2.StartPos = global_position
			add_sibling.call_deferred(instance2)
			var instance3 = bullet.instantiate()
			instance3.direction = (global_transform.basis.z.normalized() * -1 + global_transform.basis.x.normalized() * 0.2) * (SPEED * 1.5)
			instance3.StartPos = global_position
			add_sibling.call_deferred(instance3)
			times_left_shot -= 1

func generate_new_number(from: float, to: float, is_int: bool) -> float:
	var number = random_number.randf_range(from, to)
	if is_int:
		number = int(number)
	return number

func _on_timer_3_timeout() -> void:
	if not parry_shots_emmitted:
		var instance = bullet.instantiate()
		instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
		instance.StartPos = global_position
		add_sibling.call_deferred(instance)
		var instance2 = bullet.instantiate()
		instance2.direction = global_transform.basis.z.normalized() * 1 * SPEED
		instance2.StartPos = global_position
		add_sibling.call_deferred(instance2)
	else:
		var instance = parry_bullet.instantiate()
		instance.direction = global_transform.basis.z.normalized() * -1 * SPEED
		instance.StartPos = global_position
		add_sibling.call_deferred(instance)
		var instance2 = parry_bullet.instantiate()
		instance2.direction = global_transform.basis.z.normalized() * 1 * SPEED
		instance2.StartPos = global_position
		add_sibling.call_deferred(instance2)
		parry_shots -= 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		StatHandler.spawn_boss_death_particles(global_position, 0.25, true, 5)
		StatHandler.spawn_boss_death_particles(global_position, 0.3, true, 4)
		StatHandler.spawn_boss_death_particles(global_position, 0.35, true, 5)
		StatHandler.spawn_boss_death_particles(global_position, 0.4, true, 3)
		queue_free()

func death_particles(pos: Vector3):
	StatHandler.spawn_boss_death_particles(global_position + pos, 1, true, 0.8)

func play_hit_sound():
	audio_stream_player_2.play()

func teleport():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func create_overlay():
	var instance = explode_overlay.instantiate()
	add_sibling.call_deferred(instance)

func spawn_final_boom():
	var instance = final_boom.instantiate()
	add_sibling.call_deferred(instance)
