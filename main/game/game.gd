extends Node

# ui layers
@onready var main_menu: Control = $UILayer/MainMenu
@onready var game_menu: Control = $UILayer/GameMenu
@onready var end_day_screen: Control = $UILayer/EndDayScreen
@onready var pause_menu: Control = $UILayer/PauseMenu
@onready var game_over_screen: Control = $UILayer/GameOverScreen

# view manager
@onready var view_manager: Node2D = $ViewManager

# day timer
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# show main menu while hiding the other ui's
	main_menu.show()
	game_menu.hide()
	pause_menu.hide()
	game_over_screen.hide()
	end_day_screen.hide()
	
	# conenct global signals
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_call_game_over)
	GameManager.restart_game.connect(_on_game_started)
	GameManager.back_to_main_menu.connect(_on_main_menu)
	
	# pause running gameplay nodes
	view_manager.process_mode = PROCESS_MODE_DISABLED


# start game on menu (connected to global signal emmited from main menu)
func _on_game_started() -> void:
	# show game menu while hiding the other ui's
	game_menu.show()
	main_menu.hide()
	pause_menu.hide()
	game_over_screen.hide()
	end_day_screen.hide()
	
	# unpause running gameplay nodes
	view_manager.process_mode = PROCESS_MODE_INHERIT
	
	# set timer and start
	timer.wait_time = GameManager.time_remaining
	timer.start()


# set timer runs out (1 day)
func _on_timer_timeout() -> void:
	# pause running gameplay nodes
	view_manager.process_mode = PROCESS_MODE_DISABLED
	
	end_day_screen.calculate_stats()
	
	# show game menu while hiding the other ui's
	end_day_screen.show()
	main_menu.hide()
	game_menu.hide()
	pause_menu.hide()
	game_over_screen.hide()


# change views between driver and passenger
func _on_game_menu_change_view(current_view: String) -> void:
	view_manager.switch_view(current_view)


# starts up the next day
func _on_next_day() -> void:
	end_day_screen.hide()
	view_manager._ready()
	GameManager._next_day() # reset variables in the day (money, passenger_count, etc.)
	GameManager.game_started.emit()


func _on_call_game_over(reason: String) -> void:
	game_over_screen.display_game_over(reason)
	
	# show game menu while hiding the other ui's
	game_over_screen.show()
	main_menu.hide()
	game_menu.hide()
	pause_menu.hide()
	end_day_screen.hide()


# back to main menu
func _on_main_menu() -> void:
	#timer.paused = false
	timer.stop()
	view_manager.process_mode = PROCESS_MODE_DISABLED
	
	# show game menu while hiding the other ui's
	main_menu.show()
	game_menu.hide()
	pause_menu.hide()
	game_over_screen.hide()
	end_day_screen.hide()

# pause button pressed
func _on_pause_button() -> void:
	view_manager.process_mode = Node.PROCESS_MODE_DISABLED
	timer.paused = true
	pause_menu.show()

# unpause button pressed
func _on_unpause_pressed() -> void:
	view_manager.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.hide()
	timer.paused = false

# game over restart button is pressed
func _on_game_over_restart() -> void:
	pass # Replace with function body.
