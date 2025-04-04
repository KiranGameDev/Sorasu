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
@onready var center_container_2: CenterContainer = $UI/CenterContainer2
@onready var ui: Control = $UI
@onready var camera_3d: Camera3D = $Camera3D
@onready var sub_viewport: SubViewport = $SubViewport

var started = false
var player = preload("res://player.tscn")
var original_lives = 3
var dead = false
var timer_started = false
var boss_timer_started = false
var combined_score = StatHandler.score + int(boss_timer.time_left * 100) + (StatHandler.lives * 5000)

func _ready() -> void:
	StatHandler.boss_dead = false
	StatHandler.boss_ready = false
	StatHandler.lives = 2
	StatHandler.continues = StatHandler.max_continues
	StatHandler.time_up = false
	StatHandler.kill_player = false
	center_container_2.visible = false
	boss_timer_started = false
	boss_time_label.visible = false

func _process(delta: float) -> void:
	if combined_score > StatHandler.hi_score:
		update_hi_score(combined_score)
	RenderingServer.viewport_set_msaa_3d(camera_3d.get_camera_rid(), StatHandler.quality)
	center_container_2.visible = true
	if boss_timer.time_left > 0:
		StatHandler.time_up = false
	final_score_label.text = "SCORE: " + str(combined_score)
	normal_score_label.text = "Boss score: " + str(StatHandler.score)
	time_score_label.text = "Time score: " + str(int(boss_timer.time_left * 100))
	lives_score_label.text = "Lives score: " + str(StatHandler.lives * 5000)
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
	if StatHandler.boss_dead or player == null:
		boss_timer.paused = true
	else:
		boss_timer.paused = false
	label_2.text = "Continue?   " + str(int(continue_timer.time_left))
	if dead:
		if can_continue:
			if Input.is_action_just_pressed("menu"):
				if StatHandler.continues > 0:
					var raw_instance = preload("res://player.tscn")
					continue_timer.stop()
					StatHandler.lives = 2
					StatHandler.continues -= 1
					death_gui.visible = false
					lives_label.visible = true
					dead = false
					death_timer.start()
					continue_timer.stop()

func _on_death_timer_timeout() -> void:
	if StatHandler.lives > -1:
		var instance = player.instantiate()
		add_sibling.call_deferred(instance)
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
	SaveSystem.save_data(combined_score)
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_timer_timeout() -> void:
	animation_player_4.play("Fade")
	timer.stop()

func _on_boss_timer_timeout() -> void:
	StatHandler.time_up = true

func update_hi_score(score):
	StatHandler.hi_score = score
