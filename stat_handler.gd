extends Node

@export var lives = 2

var parry_line_instance = preload("res://parry_line.tscn")
var parried_bullet = preload("res://parried_bullet.tscn")
var parried_bullet_hit_particles = preload("res://parried_bullet_hit.tscn")
var grenade_particles = preload("res://grenade_explode_particles.tscn")
var boss_death_particles = preload("res://boss_death_particles.tscn")
var player_death_particles = preload("res://player_death_particles.tscn")
var enemy_hit_sound = preload("res://hit_sound.tscn")
var explode_overlay = preload("res://explode_overlay.tscn")
var score = 0
var hi_score = 0
var quality = 3
var color_blind_mode = false
var parry_combo = 0
var parry_combo_timer_started = false
var boss_spawned = false
var parried = false
var boss_position: Vector3
var boss_ready = false
var boss_dead = false
var boss_1_name = "Rokanshu"
var max_continues = 3
var continues = max_continues
var current_boss_name = boss_1_name
var kill_player = false
var time_up = false
var kill_boss_timer = false

func spawn_parry_bullet(enemy_pos, start_pos):
	var instance = parried_bullet.instantiate()
	instance.target_pos = enemy_pos
	instance.start_pos = start_pos
	add_sibling.call_deferred(instance)

func spawn_enemy_hit_sound():
	var instance = enemy_hit_sound.instantiate()
	add_sibling.call_deferred(instance)

func spawn_boss_death_particles(pos: Vector3, speed_scale: float, emitting: bool, size_scale: float):
	var instance = boss_death_particles.instantiate()
	instance.global_position = pos
	instance.speed = speed_scale
	instance.emitting = emitting
	instance.scale = Vector3(size_scale, size_scale, size_scale)
	add_sibling.call_deferred(instance)

func spawn_player_death_particles(pos: Vector3, speed_scale: float, emitting: bool, size_scale: float):
	var instance = player_death_particles.instantiate()
	instance.global_position = pos
	instance.speed = speed_scale
	instance.emitting = emitting
	instance.scale = Vector3(size_scale, size_scale, size_scale)
	add_sibling.call_deferred(instance)

func spawn_parried_bullet_hit_particle(pos: Vector3):
	var instance = parried_bullet_hit_particles.instantiate()
	instance.global_position = pos
	instance.emitting = true
	add_child.call_deferred(instance)

func exploding_grenade_particles(pos: Vector3):
	var instance = grenade_particles.instantiate()
	instance.global_position = pos
	instance.emitting = true
	add_child.call_deferred(instance)

func parry_line(start_pos: Vector3, end_pos: Vector3, color: Color, thickness: float, persist_ms: float):
	var line = parry_line_instance.instantiate()
	add_child(line)
	line.scale = Vector3(0.01 * thickness, 0.01 * thickness, start_pos.distance_to(end_pos))
	line.look_at_from_position((start_pos + end_pos) / 2, end_pos, Vector3.UP)
	
	return await final_cleanup(line, persist_ms)

func final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float):
	get_tree().get_root().add_child(mesh_instance)
	if persist_ms == 1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance
