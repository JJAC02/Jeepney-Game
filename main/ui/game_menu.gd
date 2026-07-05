extends Control


signal change_view(current_view: String)
signal pause_game


@onready var progress_bar: ProgressBar = $stress_level/ProgressBar
@onready var current_day: Label = $day_count/current_day
@onready var passenger_count: Label = $passenger/passenger_count
@onready var target_money: Label = $target_goal/target_money


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = GameManager.fatigue_level
	current_day.text = str(GameManager.day)
	passenger_count.text = str(GameManager.passenger_count)
	target_money.text = str(GameManager.money_goal)


func _process(_delta: float) -> void:
	passenger_count.text = str(GameManager.passenger_count)
	target_money.text = str(GameManager.money_goal)


func _on_cabin_pressed() -> void:
	change_view.emit(GameManager.current_view)


func _on_pause_button_pressed() -> void:
	pause_game.emit()
