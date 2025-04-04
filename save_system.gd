extends Node

var savefile = "user://savefile.save"

func save_data(score):
	if score > StatHandler.hi_score:
		var file = FileAccess.open(savefile, FileAccess.WRITE)
		file.store_float(score)
		file.close()

func load_data():
	if FileAccess.file_exists(savefile):
		var file = FileAccess.open(savefile, FileAccess.READ)
		StatHandler.hi_score = file.get_float()
		file.close()
	else:
		StatHandler.hi_score = 0

func erase_save():
	if FileAccess.file_exists(savefile):
		var file = FileAccess.open(savefile, FileAccess.WRITE)
		file.store_float(0)
