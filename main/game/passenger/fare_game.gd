extends Node
class_name FareGame
## Headless fare-and-change engine for the passenger view.
## A passenger boards, states a fare, and hands over a bill. The player
## assembles exact change from denomination buttons before the timer runs out.
## The view layer binds UI to the signals and calls add()/undo()/submit().

signal round_started(fare: int, paid: int, change_due: int, destination: String)
signal change_changed(current: int, due: int)
signal round_resolved(outcome: String, money_delta: int, satisfaction_delta: float)
signal tick(time_left: float, round_time: float)

# Denominations the driver can hand back as change (PHP coins/small bills).
@export var denominations: Array[int] = [1, 5, 10, 20]
# Bills passengers pay with.
@export var pay_bills: Array[int] = [20, 50, 100]
# Possible fares (regular / discounted).
@export var fares: Array[int] = [12, 13, 15]
@export var round_time: float = 8.0
@export var speed_bonus_window: float = 3.0   # submit within N sec of solving for a tip

const DESTINATIONS := [
	"Cubao", "Monumento", "Baclaran", "Divisoria", "Fairview",
	"Ayala", "Kalaw", "Quiapo", "SM North", "Alabang",
]

var fare: int = 0
var paid: int = 0
var change_due: int = 0
var current_change: int = 0
var time_left: float = 0.0
var active: bool = false

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	set_process(false)

## Begin a new passenger. Guarantees paid > fare so change is always owed.
func start_round() -> void:
	fare = fares[_rng.randi_range(0, fares.size() - 1)]
	# Pick a paying bill strictly greater than the fare.
	var valid: Array[int] = pay_bills.filter(func(b): return b > fare)
	paid = valid[_rng.randi_range(0, valid.size() - 1)]
	change_due = paid - fare
	current_change = 0
	time_left = round_time
	active = true
	set_process(true)
	var dest: String = DESTINATIONS[_rng.randi_range(0, DESTINATIONS.size() - 1)]
	round_started.emit(fare, paid, change_due, dest)
	change_changed.emit(current_change, change_due)

## Player taps a denomination to add to the change pile.
func add(value: int) -> void:
	if not active:
		return
	current_change += value
	change_changed.emit(current_change, change_due)

## Remove the last-equivalent denomination (simple undo by value).
func subtract(value: int) -> void:
	if not active:
		return
	current_change = maxi(0, current_change - value)
	change_changed.emit(current_change, change_due)

func clear() -> void:
	if not active:
		return
	current_change = 0
	change_changed.emit(current_change, change_due)

## Player hands the change over. Resolves the round.
func submit() -> void:
	if not active:
		return
	if current_change == change_due:
		_resolve("correct")
	elif current_change > change_due:
		_resolve("over")
	else:
		_resolve("under")

func _process(delta: float) -> void:
	if not active:
		return
	time_left -= delta
	tick.emit(time_left, round_time)
	if time_left <= 0.0:
		_resolve("timeout")

func _resolve(outcome: String) -> void:
	active = false
	set_process(false)
	var money_delta := 0
	var sat := 0.0
	match outcome:
		"correct":
			# Collected the fare; quick service earns a small tip.
			money_delta = fare
			sat = 0.10
			var speed: float = clampf(time_left / speed_bonus_window, 0.0, 1.0)
			money_delta += int(round(speed * 2.0))   # up to +2 tip
		"over":
			# Gave back too much — you eat the difference but keep the fare.
			money_delta = fare - (current_change - change_due)
			sat = 0.02
		"under":
			# Shortchanged the passenger — they're unhappy, fare withheld partly.
			money_delta = 0
			sat = -0.12
		"timeout":
			# Too slow — passenger leaves annoyed without paying full.
			money_delta = 0
			sat = -0.15
	round_resolved.emit(outcome, money_delta, sat)
