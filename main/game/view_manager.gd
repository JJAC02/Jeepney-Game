extends Node2D

@onready var driver_view: Camera2D = $DriverView/Camera2D
@onready var passenger_view: Camera2D = $PassengerView/Camera2D
@onready var passenger_slots: Node2D = $PassengerView/slots

var pan_speed: float = 200
var margin: float = 225

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in passenger_slots.get_children():
		for grandchild in child.get_children():
			grandchild.queue_free()
	driver_view.make_current()

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos)
	var viewport_size = get_viewport().get_visible_rect().size
	#print(viewport_size)
	if mouse_pos.x >= (viewport_size.x - margin):
		position.x -= pan_speed * delta
	elif mouse_pos.x <= margin:
		position.x += pan_speed * delta

func switch_view(current_view: String) -> void:
	if current_view == "driver":
		passenger_view.make_current()
		GameManager.current_view = "passenger"
		print("change to passenger")
	elif current_view == "passenger":
		driver_view.make_current()
		GameManager.current_view = "driver"
		print("change to driver")
