extends Node2D

var passenger: PackedScene = preload("res://main/game/passenger/Passenger.tscn")
@onready var timer: Timer = $Timer
@onready var seat_slots: Node2D = $"../../PassengerView/slots"

var is_picked_up: bool = false # suggestion: let passenger track its own pickup state instead of letting this script handle it
var seat_idx: int = -1
var individual_passenger = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_started.connect(start_randTimer)
	start_randTimer()

func start_randTimer() -> void:
	timer.wait_time = randf_range(1.00, 3.00)
	timer.one_shot = true
	timer.start()

func start_spawning():
	is_picked_up = false
	var passenger_instance = passenger.instantiate()
	add_child(passenger_instance)
	passenger_instance.transfer_me.connect(picked_up)
	individual_passenger = passenger_instance
	

func _on_timer_timeout() -> void:
	if individual_passenger == null or is_picked_up:
		start_spawning()
	else:
		individual_passenger.queue_free()
		individual_passenger = null
	
	is_picked_up = false
	start_randTimer()

func picked_up(inst: Node2D):
	if individual_passenger == null: # safety catch
		return
	print("signal pickup received")
	var take_seat: Marker2D = you_yizi()
	if take_seat != null:
		is_picked_up = true
		inst.reparent(take_seat)
		inst.position = Vector2.ZERO
		inst.go_in(seat_idx)
	else:
		print("full")
		inst.show_full()
	
func you_yizi() -> Marker2D:
	var seats = seat_slots.get_children()
	seat_idx = -1
	for i in range(seats.size()):
		var seat: Marker2D = seats[i]
		if seat.get_child_count() == 0:
			seat_idx = i
			return seat
		
	return null
