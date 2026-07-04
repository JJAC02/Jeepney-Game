extends Node2D

var passenger: PackedScene = preload("res://main/game/passenger/Passenger.tscn")
@onready var timer: Timer = $Timer
@onready var seat_slots: Node2D = $"../../PassengerView/slots"

var seat_idx: int = -1
var individual_passenger = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_started.connect(start_randTimer)

func start_randTimer() -> void:
	timer.wait_time = randf_range(1.00, 3.00)
	timer.one_shot = true
	timer.start()

func start_spawning():
	var passenger_instance = passenger.instantiate()
	add_child(passenger_instance)
	passenger_instance.transfer_me.connect(picked_up)
	individual_passenger = passenger_instance
	

func _on_timer_timeout() -> void:
	if individual_passenger == null:
		start_spawning()
	else:
		individual_passenger.queue_free()
		individual_passenger = null
	
	start_randTimer()

func setup_instance(inst: Node2D) -> void:
	inst.position = Vector2.ZERO
	inst.go_in(seat_idx)
	inst.plite_timeout()
	var mult:= 1.2 * pow(2.2/1.2, float(seat_idx%8)/7.0)
	inst.scale = Vector2.ONE*mult
func picked_up(inst: Node2D):
	if individual_passenger == null: # safety catch
		return
	print("signal pickup received")
	var take_seat: Marker2D = you_yizi()
	if take_seat != null:
		inst.reparent(take_seat)
		setup_instance(inst)
		individual_passenger = null
	else:
		print("full")
		inst.show_full()
	
func you_yizi() -> Marker2D:
	var seats = seat_slots.get_children()
	var idxList = range(seats.size())
	idxList.shuffle()
	seat_idx = -1
	for i in idxList:
		var seat: Marker2D = seats[i]
		if seat.get_child_count() == 0:
			seat_idx = i
			return seat
		
	return null
