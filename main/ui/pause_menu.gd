extends Control

signal unpause_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_unpause_pressed() -> void:
	unpause_pressed.emit()


func _on_menu_pressed() -> void:
	GameManager.back_to_main_menu.emit(self)
