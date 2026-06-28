extends Node

const views = preload("res://main/game/Game.tscn")

@onready var main_menu: Control = $UILayer/MainMenu
@onready var view_manager: Node2D = $ViewManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_started.connect(_on_game_started)
	#view_manager.visisble = false
	view_manager.process_mode = PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_started() -> void:
	main_menu.queue_free() 
	#view_manager.visisble = true
	view_manager.process_mode = PROCESS_MODE_INHERIT
