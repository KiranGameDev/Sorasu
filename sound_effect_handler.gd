extends Node
class_name SoundHandler

@onready var enemy_death: AudioStreamPlayer = $EnemyDeath

func play_enemy_death(volume: float, pitch_scale: float):
	enemy_death.volume_db = volume
	enemy_death.pitch_scale = pitch_scale
	enemy_death.play()
