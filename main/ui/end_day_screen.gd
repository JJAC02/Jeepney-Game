extends Control

signal next_day(day_number: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_button_pressed() -> void:
	GameManager.day += 1
	next_day.emit()


func _on_menu_pressed() -> void:
	GameManager.back_to_main_menu.emit(self)
