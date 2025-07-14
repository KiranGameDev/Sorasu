extends CharacterBody3D

@export var defense_upgrade = 6
@export var max_livechance_range = 30
@export var doing_parry = false
@export var parry_finished = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var parry_animation_player: AnimationPlayer = $ParryAnimationPlayer
@onready var spaceshipmodel: Node3D = $PlayerModel
@onready var parry_sound_effect: AudioStreamPlayer = $SFX/ParrySoundEffect
@onready var combo_timer: Timer = $ComboTimer
@onready var parry_sound_effect_2: AudioStreamPlayer = $SFX/ParrySoundEffect2
@onready var max_combo_voice: AudioStreamPlayer = $"SFX/Max Combo Voice"
@onready var parry_pause_timer: Timer = $ParryPauseTimer

var SPEED = 21
var BULLET_SPEED = 50
var LIVECHANCE = RandomNumberGenerator.new()
var hit = false
var invincible = true
var live_chance = LIVECHANCE.randi_range(1, max_livechance_range)
var spin_dir_generator = RandomNumberGenerator.new()

func _ready() -> void:
	hit = false
	if StatHandler.ex_mode:
		Engine.time_scale = 1.3
	else:
		Engine.time_scale = 1

func _process(delta: float) -> void:
	StatHandler.kill_player = false
	combo_timer.wait_time = 6.0 / StatHandler.parry_combo
	StatHandler.parry_timer_number = 0 + combo_timer.wait_time
	StatHandler.parry_timer_time = 0 + combo_timer.time_left
	if StatHandler.parry_combo > 9:
		max_combo_voice.play()
		StatHandler.parry_combo = 9
	if StatHandler.parry_combo > 0 and not StatHandler.parry_combo_timer_started:
		combo_timer.start()
		StatHandler.parry_combo_timer_started = true
	if StatHandler.parry_combo <= 0:
		combo_timer.stop()
		StatHandler.parry_combo_timer_started = false
	if not animation_player.is_playing():
		spaceshipmodel.rotation.x = 0
	if hit:
		StatHandler.lives -= 1
		StatHandler.deaths += 1
		StatHandler.parry_combo = 0
		StatHandler.spawn_player_death_particles(global_position, 0.5, true, 1)
		if StatHandler.ex_mode:
			Engine.time_scale = 1#.3
		else:
			Engine.time_scale = 1
		queue_free()
	if StatHandler.kill_player == true:
		StatHandler.parry_combo = 0
		combo_timer.stop()
		StatHandler.parry_combo_timer_started = false
		Engine.time_scale = 1
		queue_free()

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("down", "up", "left", "right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if not StatHandler.in_tutorial:
		check_parry()
		move_and_slide()
	else:
		check_tutorial_parry()

func _on_parry_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("parry_bullet"):
		body.in_parry_zone = true

func _on_parry_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("parry_bullet"):
		body.in_parry_zone = false

func check_parry():
	if Input.is_action_just_pressed("parry"):
		if not parry_finished:
			if not doing_parry:
				parry_animation_player.play("ParryBegin")
				var spin_dir = spin_dir_generator.randi_range(1, 2)
				if spin_dir == 1:
					animation_player.play("BarrelRoll")
				else:
					animation_player.play_backwards("BarrelRoll")
				doing_parry = true
	if parry_finished:
		if StatHandler.parried:
			parry_animation_player.play("ParrySuccessful")
			if not parry_sound_effect.playing:
				parry_pause_timer.start()
				Engine.time_scale = 0.1
				parry_sound_effect.play()
				parry_sound_effect_2.play()
		else:
			parry_animation_player.play("BadParry")

func check_tutorial_parry():
	if StatHandler.tutorial_parry:
		if not doing_parry:
			parry_animation_player.play("ParryBegin")
			var spin_dir = spin_dir_generator.randi_range(1, 2)
			if spin_dir == 1:
				animation_player.play("BarrelRoll")
			else:
				animation_player.play_backwards("BarrelRoll")
				doing_parry = true
			StatHandler.tutorial_parry = false
	if parry_finished:
		if StatHandler.parried:
			parry_animation_player.play("ParrySuccessful")
			if not parry_sound_effect.playing:
				parry_pause_timer.start()
				Engine.time_scale = 0.1
				parry_sound_effect.play()
				parry_sound_effect_2.play()
		else:
			parry_animation_player.play("BadParry")

func parry_finish():
	StatHandler.parried = false

func swap_physics_process():
	set_physics_process(!is_physics_processing())

func _on_combo_timer_timeout() -> void:
	StatHandler.parry_combo -= 1
	combo_timer.start()

func delete():
	StatHandler.kill_player = true

func _on_timer_timeout() -> void:
	invincible = false

func _on_parry_pause_timer_timeout() -> void:
	if StatHandler.ex_mode:
		Engine.time_scale = 1#.3
	else:
		Engine.time_scale = 1
