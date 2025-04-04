extends Node3D

var enemy = preload("res://enemy_1.tscn")

@onready var prototype_boss: CharacterBody3D = $"../PrototypeBoss"
@onready var timer: Timer = $Timer

func spawn_enemy():
	if StatHandler.boss_ready:
		var instance = enemy.instantiate()
		instance.move_on = true
		add_child.call_deferred(instance)

func _on_timer_timeout() -> void:
	if prototype_boss.phase != 3:
		var player = get_tree().get_first_node_in_group("player")
		if player != null:
			spawn_enemy()
