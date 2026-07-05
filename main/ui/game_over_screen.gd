extends Control

@onready var try_again: TextureButton = $HBoxContainer/TryAgain
@onready var main_menu: TextureButton = $HBoxContainer/MainMenu
@onready var reason_lost: Label = $Reason
@onready var days_total: Label = $VBoxContainer/days_total
@onready var passengers_total: Label = $VBoxContainer/passengers_total
@onready var money_total: Label = $VBoxContainer/money_total
@onready var points_total: Label = $VBoxContainer/points_total


func display_game_over(reason: String):
	reason_lost.text = "Lost due to: " + reason
	days_total.text = str(GameManager.total_days) + " days"
	passengers_total.text = str(GameManager.total_passengers) + "x"
	money_total.text = "Php " + str(GameManager.total_money)
	points_total.text = str(GameManager.total_points)


func _on_menu_pressed() -> void:
	GameManager.back_to_main_menu.emit()


func _on_try_again_pressed() -> void:
	GameManager.restart_game.emit()
