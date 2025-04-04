extends Node3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio_stream_player.play()

func _on_audio_stream_player_finished() -> void:
	queue_free()
