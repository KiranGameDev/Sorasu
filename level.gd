extends Node3D

@export var can_continue = false

@onready var animation_player_4: AnimationPlayer = $AnimationPlayer4
@onready var death_timer: Timer = $DeathTimer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var lives_label: Label = $UI/LivesLabel
@onready var death_gui: Control = $UI/DeathGUI
@onready var boss_animation_player: AnimationPlayer = $PrototypeBoss/BossAnimationPlayer
@onready var label_2: Label = $UI/DeathGUI/Label2
@onready var continue_timer: Timer = $UI/DeathGUI/ContinueTimer
@onready var timer: Timer = $Timer
@onready var boss_timer: Timer = $BossTimer
@onready var boss_time_label: Label = $UI/BossTimeLabel
@onready var boss: CharacterBody3D = $PrototypeBoss
@onready var score_label: Label = $UI/CenterContainer/ScoreLabel
@onready var final_score_label: Label = $UI/CenterContainer2/VBoxContainer/Label
@onready var normal_score_label: Label = $UI/CenterContainer2/VBoxContainer/Label2
@onready var time_score_label: Label = $UI/CenterContainer2/VBoxContainer/Label3
@onready var lives_score_label: Label = $UI/CenterContainer2/VBoxContainer/Label4
@onready var difficulty_score_label: Label = $UI/CenterContainer2/VBoxContainer/Label5
@onready var center_container_2: CenterContainer = $UI/CenterContainer2
@onready var ui: Control = $UI
@onready var camera_3d: Camera3D = $Camera3D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var floor_2: CSGMesh3D = $Floor2
@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3
@onready var parry_combo_label: Label = $UI/CenterContainer3/ParryComboLabel
@onready var parry_bar: ProgressBar = $UI/ParryBar
@onready var respawn_voice: AudioStreamPlayer = $RespawnVoice

var started = false
var player = preload("res://player.tscn")
var original_lives = 3
var dead = false
var timer_started = false
var boss_timer_started = false
var combined_score = StatHandler.score + int(StatHandler.lives * 5000)
var difficulty_score = -(StatHandler.max_lives - 4) * 1000
var death_score

func _ready() -> void:
	if StatHandler.color_blind_mode:
		floor_2.visible = true
	else:
		floor_2.visible = false
	StatHandler.boss_dead = false
	StatHandler.boss_ready = false
	StatHandler.lives = StatHandler.max_lives
	StatHandler.continues = StatHandler.max_continues
	StatHandler.time_up = false
	StatHandler.kill_player = false
	center_container_2.visible = false
	boss_timer_started = false
	boss_time_label.visible = false

func _process(delta: float) -> void:
	if StatHandler.boss_dead:
		StatHandler.parry_combo = 0
	StatHandler.set_fps(StatHandler.max_fps)
	parry_bar.max_value = StatHandler.parry_timer_number
	death_score = 0 - (StatHandler.deaths * 500)
	parry_bar.value = StatHandler.parry_timer_time
	parry_combo_label.text = "x" + str(StatHandler.parry_combo)
	if StatHandler.prev_parry_combo != StatHandler.parry_combo:
		animation_player_3.play("ParryLabelPop")
		StatHandler.prev_parry_combo = StatHandler.parry_combo
	if StatHandler.parry_combo <= 0:
		parry_combo_label.visible = false
		parry_bar.visible = false
	else:
		parry_combo_label.visible = true
		parry_bar.visible = true
	var time_score = (int(boss_timer.time_left) * 100)
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_viewport().get_viewport_rid(), StatHandler.get_msaa_quality(StatHandler.quality))
	center_container_2.visible = true
	if boss_timer.time_left > 0:
		StatHandler.time_up = false
	final_score_label.text = "SCORE: " + str(StatHandler.score + death_score + time_score + difficulty_score)
	normal_score_label.text = "Boss score: " + str(StatHandler.score)
	time_score_label.text = "Time score: " + str(time_score)
	difficulty_score_label.text = "Difficulty bonus: +" + str(difficulty_score)
	lives_score_label.text = "Deaths penalty: " + str(int(death_score))
	if StatHandler.kill_boss_timer:
		boss_timer.paused = true
	boss_time_label.text = "Time Left: " + str(int(boss_timer.time_left))
	score_label.text = "Score: " + str(int(StatHandler.score))
	if StatHandler.boss_ready and not boss_timer_started:
		boss_timer.start()
		boss_time_label.visible = true
		boss_timer_started = true
	if StatHandler.boss_dead:
		if not timer_started:
			StatHandler.score += 10000
			timer.start()
			timer_started = true
	if StatHandler.time_up:
		if not timer_started:
			timer.start()
			timer.wait_time = 3
			timer_started = true
	if StatHandler.lives <= -1:
		if not dead:
			lives_label.visible = false
			animation_player_2.play("DeathFadeIn")
			dead = true
	lives_label.text = "LIVES: " + str(StatHandler.lives)
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		if not started:
			death_timer.start()
			started = true
	else:
		started = false
		continue_timer.stop()
	if StatHandler.boss_dead or player == null:
		boss_timer.paused = true
	else:
		boss_timer.paused = false
	label_2.text = "Continue?   " + str(int(continue_timer.time_left))
	if dead:
		if can_continue:
			if not continue_timer.is_stopped():
				if Input.is_action_just_pressed("menu"):
					if StatHandler.continues > 0:
						var raw_instance = preload("res://player.tscn")
						continue_timer.stop()
						StatHandler.lives = StatHandler.max_lives
						StatHandler.continues -= 1
						death_gui.visible = false
						lives_label.visible = true
						dead = false
						death_timer.start()
						continue_timer.stop()
	if StatHandler.continues < 0:
		StatHandler.continues = 0

func _on_death_timer_timeout() -> void:
	if StatHandler.lives > -1:
		var instance = player.instantiate()
		add_sibling.call_deferred(instance)
		respawn_voice.play()
		started = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_timer_3_timeout() -> void:
	boss_animation_player.play("Enter")

func start_continue_countdown():
	if StatHandler.continues <= 0:
		game_over()
	else:
		label_2.visible = true

func game_over():
	continue_timer.stop()
	animation_player_2.play("DeathFadeOut")

func _on_continue_timer_timeout() -> void:
	game_over()

func teleport():
	StatHandler.kill_player = true
	get_tree().change_scene_to_file("res://main_menu.tscn")

func go_to_next_level():
	StatHandler.kill_player = true
	get_tree().change_scene_to_file("res://level_2.tscn")

func save():
	var time_score = (int(boss_timer.time_left) * 100)
	if StatHandler.boss_dead:
		SaveSystem.save_data(StatHandler.score + (StatHandler.lives * 5000) + time_score)
	else:
		SaveSystem.save_data(StatHandler.score)

func _on_timer_timeout() -> void:
	animation_player_4.play("Fade")
	timer.stop()

func _on_boss_timer_timeout() -> void:
	StatHandler.time_up = true

func update_hi_score(score):
	StatHandler.hi_score_1 = score
