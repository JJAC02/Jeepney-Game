extends Node

@warning_ignore("unused_signal") signal game_started
#signal game_over(score: int)
@warning_ignore("unused_signal") signal back_to_main_menu(node_self: Control)

@warning_ignore("unused_signal") signal game_over

# variables persist over different days
var day: int = 1
var money_goal: int = 100

# variables reset per day
var current_view: String = "driver"
var money: int = 50
var passenger_count: int = 0
var stress_level: float = 5.0
var passenger_satisfaction: float = 5.0
var time_remaining: float = 10.0 # in seconds

# variables persist over different days
var total_money: int = 0
var total_days: int = 1

#passenger metadata
var is_regular: bool 
var fare_received: int

# when the game runs for the very first time
func _initialize_game() -> void:
	fare_received = 0
	day = 1
	money_goal = 100
	current_view = "driver"
	money = 50
	passenger_count = 0
	stress_level = 5.0
	passenger_satisfaction = 5.0
	time_remaining = 10.0
	total_money = 0
	total_days = 1
	

func _ready() -> void:
	# Keep singleton active even when scene tree pauses
	process_mode = Node.PROCESS_MODE_ALWAYS
	_initialize_game()

func update_money(amount: int) -> void:
	money += amount
	total_money += amount

func _next_day():
	day += 1
	money_goal += 100 # improve difficulty scaling
	fare_received = 0
	
	current_view = "driver"
	money = 50
	passenger_count = 0
	stress_level = 5.0
	passenger_satisfaction = 5.0
	time_remaining = 10.0
