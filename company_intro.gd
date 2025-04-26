extends Control

func start_load():
	SaveSystem.load_data()

func teleport():
	get_tree().change_scene_to_file("res://start_menu.tscn")
