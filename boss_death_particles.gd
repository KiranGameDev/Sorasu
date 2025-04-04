extends Node3D

@onready var gpu_particles_3d_1: GPUParticles3D = $GPUParticles3D1
@onready var gpu_particles_3d_2: GPUParticles3D = $GPUParticles3D2
@onready var gpu_particles_3d_3: GPUParticles3D = $GPUParticles3D3
@onready var gpu_particles_3d_4: GPUParticles3D = $GPUParticles3D4
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var speed: float
var emitting: bool

func _ready() -> void:
	audio_stream_player.play()
	gpu_particles_3d_1.emitting = emitting
	gpu_particles_3d_2.emitting = emitting
	gpu_particles_3d_3.emitting = emitting
	gpu_particles_3d_4.emitting = emitting
	gpu_particles_3d_1.speed_scale = speed
	gpu_particles_3d_2.speed_scale = speed
	gpu_particles_3d_3.speed_scale = speed
	gpu_particles_3d_4.speed_scale = speed
