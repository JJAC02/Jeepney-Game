extends Control

signal change_view(current_view: String)
signal pause_game
@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = GameManager.stress_level


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_button_pressed() -> void:
	change_view.emit(GameManager.current_view)


func _on_pause_button_pressed() -> void:
	pause_game.emit()
