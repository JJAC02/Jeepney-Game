extends Node2D

@onready var passenger: PackedScene = preload("res://main/game/passenger/Passenger.tscn")
@onready var timer: Timer = $Timer
@onready var seat_slots: Node2D = $"../../PassengerView/slots"

var is_picked_up: bool = false
var seat_idx: int = -1
var individualPassenger = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_started.connect(start_randTimer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_init():
	start_randTimer()

func start_randTimer() -> void:
	timer.wait_time = randf_range(1.00, 3.00)
	timer.one_shot = true
	timer.start()

func start_spawning():
	var passengerInstance = passenger.instantiate()
	add_child(passengerInstance)
	passengerInstance.transfer_me.connect(picked_up)
	individualPassenger = passengerInstance

func _on_timer_timeout() -> void:
	if individualPassenger == null or (individualPassenger != null and is_picked_up == true):
		start_spawning()
	elif is_picked_up == false and individualPassenger != null:
		individualPassenger = null
	is_picked_up = false
	start_randTimer()
	
func picked_up():
	print("signal pickup received")
	var takeSeat: Marker2D = you_yizi()
	if takeSeat != null:
		is_picked_up = true
		individualPassenger.reparent(takeSeat)
		individualPassenger.position = Vector2.ZERO
		individualPassenger.go_in(seat_idx)
	else:
		print("full")
		individualPassenger.show_full()
	
	
func you_yizi() -> Marker2D:
	var seats = seat_slots.get_children()
	for i in range(seats.size()):
		var seat: Marker2D = seats[i]
		if seat.get_child_count() == 0:
			seat_idx = i
			return seat
		
	return null
