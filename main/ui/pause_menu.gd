extends Control

signal unpause_pressed

func _on_resume_pressed() -> void:
	unpause_pressed.emit()


func _on_menu_pressed() -> void:
	GameManager.back_to_main_menu.emit()


func _on_restart_pressed() -> void:
	GameManager.restart_game.emit()
