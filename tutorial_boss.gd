extends CSGBox3D

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		transform = transform.looking_at(player.global_position)
