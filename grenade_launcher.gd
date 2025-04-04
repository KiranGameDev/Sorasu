extends Node3D

@onready var mini_boss_1: CharacterBody3D = $".."

var enemy_1 = preload("res://enemy_1.tscn")
var number_generator = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	global_position = mini_boss_1.global_position

func _on_timer_4_timeout() -> void:
	if StatHandler.boss_ready:
		if mini_boss_1.phase != 3:
			var instance1 = enemy_1.instantiate()
			instance1.type = number_generator.randi_range(1, 2)
			add_child.call_deferred(instance1)
			var instance2 = enemy_1.instantiate()
			instance2.type = number_generator.randi_range(3, 4)
			add_child.call_deferred(instance2)
