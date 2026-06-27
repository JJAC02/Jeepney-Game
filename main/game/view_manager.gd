extends Node2D

@onready var driver_view: Node2D = $DriverView/Camera2D
@onready var passenger_view: Node2D = $PassengerView/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	driver_view.make_current()
	$DriverView.change_view.connect(switch_view)
	$PassengerView.change_view.connect(switch_view)

func switch_view(target_view: String) -> void:
	if target_view == "passenger":
		passenger_view.make_current()
	elif target_view == "driver":
		driver_view.make_current()
