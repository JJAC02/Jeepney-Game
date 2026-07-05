extends Control

func _on_start_pressed() -> void:
	GameManager.game_started.emit()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_mute_pressed() -> void:
	print("mute pressed")
