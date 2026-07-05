extends Control

signal next_day()

@onready var total_fare: Label = $VBoxContainer/total_fare
@onready var passengers_served: Label = $VBoxContainer/passengers_served
@onready var fatigue: Label = $VBoxContainer/fatigue
@onready var fuel_cost: Label = $VBoxContainer/fuel_cost
@onready var total_points: Label = $VBoxContainer/total_points
@onready var next_day_button: TextureButton = $HBoxContainer/NextDay
@onready var main_menu: TextureButton = $HBoxContainer/MainMenu
@onready var timer: Timer = $Timer
@onready var game_over: Label = $GameOver


func calculate_stats():
	game_over.hide()
	var calculated_total_points = 1000000
	
	total_fare.text = "Php " + str(GameManager.money - 50)
	passengers_served.text = str(GameManager.passenger_count) + "x"
	fatigue.text = str(GameManager.fatigue_level)
	fuel_cost.text = "-Php " + str(GameManager.money_goal)
	total_points.text = str(calculated_total_points)
	
	GameManager.total_points += calculated_total_points
	
	if GameManager.money - GameManager.money_goal < 0:
		game_over.show()
		next_day_button.hide()
		main_menu.hide()
		
		timer.start()


func _on_timer_timeout() -> void:
	GameManager.game_over.emit("Insufficient money")


func _on_next_day_button_pressed() -> void:
	next_day.emit()


func _on_menu_pressed() -> void:
	GameManager.back_to_main_menu.emit()
