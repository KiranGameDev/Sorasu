extends VBoxContainer

@onready var label: Label = $Label

func _process(delta: float) -> void:
	label.text = "A large enemy by the name of ''" + StatHandler.current_boss_name + "'' is heading to your direct location, and will arrive soon. Prepare yourself, and do not yield your position."
