extends CSGBox3D

const BULLET_SPEED = 15

var bullet = preload("res://normal_bullet.tscn")
var parry_bullet = preload("res://parry_bullet.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		transform = transform.looking_at(player.global_position)

func shoot(parryable: bool):
	animation_player.play("Shoot")
	audio_stream_player.play()
	if not parryable:
		var instance = bullet.instantiate()
		instance.direction = global_transform.basis.z.normalized() * -1 * BULLET_SPEED
		instance.StartPos = global_position
		add_sibling.call_deferred(instance)
	else:
		var instance = parry_bullet.instantiate()
		instance.direction = global_transform.basis.z.normalized() * -1 * BULLET_SPEED
		instance.StartPos = global_position
		add_sibling.call_deferred(instance)
