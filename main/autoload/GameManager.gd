extends Node

@warning_ignore("unused_signal") signal game_started
@warning_ignore("unused_signal") signal restart_game
@warning_ignore("unused_signal") signal back_to_main_menu(node_self: Control)
@warning_ignore("unused_signal") signal game_over(reason: String)

# variables that change every day
var day: int = 1
var money_goal: int = 100

# variables that reset per day
var current_view: String = "driver"
var money: int = 50
var passenger_count: int = 0
var fatigue_level: float = 5.0
var time_remaining: float = 60.0 # how long the game lasts (in seconds)

# variables persist over different days
var total_money: int = 0
var total_days: int = 1
var total_passengers: int = 0
var total_points: int = 0


func _ready() -> void:
	# Keep singleton active even when scene tree pauses
	process_mode = Node.PROCESS_MODE_ALWAYS
	absolute_restart_variables()


func reset_variables():
	current_view = "driver"
	money = 50
	passenger_count = 0
	fatigue_level = 5.0
	time_remaining = 60.0

func _next_day():
	# add to total money and days
	total_money += money
	total_days += 1
	total_passengers += passenger_count
	
	# update day number and money goal
	day += 1
	money_goal += 100 # improve difficulty scaling
	
	# reset variables
	reset_variables()

func absolute_restart_variables():
	reset_variables()
	day = 1
	money_goal = 100
	
	total_money = 0
	total_days = 1
	total_passengers = 0
	total_points = 0
