extends Node

var savefile_1 = "user://level_1.save"
var savefile_2 = "user://level_2.save"
var savefile_3 = "user://level_3.save"
var savefile_4 = "user://level_4.save"
var savefile_5 = "user://level_5.save"
var savefile_6 = "user://level_6.save"

func save_data(score):
	if StatHandler.level_to == 1:
		if score > StatHandler.hi_score_1:
			var file = FileAccess.open(savefile_1, FileAccess.WRITE)
			file.store_float(score)
			file.close()
	if StatHandler.level_to == 2:
		if score > StatHandler.hi_score_2:
			var file = FileAccess.open(savefile_2, FileAccess.WRITE)
			file.store_float(score)
			file.close()
	if StatHandler.level_to == 3:
		if score > StatHandler.hi_score_3:
			var file = FileAccess.open(savefile_3, FileAccess.WRITE)
			file.store_float(score)
			file.close()
	if StatHandler.level_to == 4:
		if score > StatHandler.hi_score_4:
			var file = FileAccess.open(savefile_4, FileAccess.WRITE)
			file.store_float(score)
			file.close()
	if StatHandler.level_to == 5:
		if score > StatHandler.hi_score_5:
			var file = FileAccess.open(savefile_5, FileAccess.WRITE)
			file.store_float(score)
			file.close()
	if StatHandler.level_to == 6:
		if score > StatHandler.hi_score_6:
			var file = FileAccess.open(savefile_6, FileAccess.WRITE)
			file.store_float(score)
			file.close()

func load_data():
	if FileAccess.file_exists(savefile_1):
		var file = FileAccess.open(savefile_1, FileAccess.READ)
		StatHandler.hi_score_1 = file.get_float()
		file.close()
	else:
		StatHandler.hi_score_1 = 0
	if FileAccess.file_exists(savefile_2):
		var file = FileAccess.open(savefile_2, FileAccess.READ)
		StatHandler.hi_score_2 = file.get_float()
		file.close()
	else:
		StatHandler.hi_score_2 = 0
	if FileAccess.file_exists(savefile_3):
		var file = FileAccess.open(savefile_3, FileAccess.READ)
		StatHandler.hi_score_3 = file.get_float()
		file.close()
	else:
		StatHandler.hi_score_3 = 0
	if FileAccess.file_exists(savefile_4):
		var file = FileAccess.open(savefile_4, FileAccess.READ)
		StatHandler.hi_score_4 = file.get_float()
		file.close()
	else:
		StatHandler.hi_score_4 = 0
	if FileAccess.file_exists(savefile_5):
		var file = FileAccess.open(savefile_5, FileAccess.READ)
		StatHandler.hi_score_5 = file.get_float()
		file.close()
	else:
		StatHandler.hi_score_5 = 0
	if FileAccess.file_exists(savefile_6):
		var file = FileAccess.open(savefile_6, FileAccess.READ)
		StatHandler.hi_score_6 = file.get_float()
		file.close()
	else:
		StatHandler.hi_score_6 = 0

func erase_save():
	if FileAccess.file_exists(savefile_1):
		var file = FileAccess.open(savefile_1, FileAccess.WRITE)
		file.store_float(0)
	if FileAccess.file_exists(savefile_2):
		var file = FileAccess.open(savefile_2, FileAccess.WRITE)
		file.store_float(0)
	if FileAccess.file_exists(savefile_3):
		var file = FileAccess.open(savefile_3, FileAccess.WRITE)
		file.store_float(0)
	if FileAccess.file_exists(savefile_4):
		var file = FileAccess.open(savefile_4, FileAccess.WRITE)
		file.store_float(0)
	if FileAccess.file_exists(savefile_5):
		var file = FileAccess.open(savefile_5, FileAccess.WRITE)
		file.store_float(0)
	if FileAccess.file_exists(savefile_6):
		var file = FileAccess.open(savefile_6, FileAccess.WRITE)
		file.store_float(0)
