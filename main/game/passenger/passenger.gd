extends Node2D

signal transfer_me(inst: Node2D)

@onready var btn: TextureButton = $TextureButton
@onready var full: Sprite2D = $full
@onready var passenger_sprite: Sprite2D = $passenger_type
@onready var label_plite: Label = $fareDisplay/fareB/Label
@onready var fare_display: Node2D = $fareDisplay
@onready var timer: Timer = $fareDisplay/Timer
@onready var dropoff_timer: Timer = $Timer
@export var male_stand: Texture2D 
@export var male_sit: Texture2D 
@export var female_stand: Texture2D
@export var female_sit: Texture2D 
@export var old_stand: Texture2D
@export var old_sit: Texture2D 
@export var M_old_sit: Texture2D
@export var M_old_stand: Texture2D


enum PassengerType {
	MALE, 
	FEMALE,
	F_OLD,
	M_OLD
}

var amt: int
var regular_track_local: bool
var type_chosen : PassengerType
var sprites := {}
func random_plite() -> int:
	var plite : Array[int] = [15, 20, 30, 40, 50, 60, 70, 80, 90, 100]
	
	return plite[randi_range(0, (plite.size())-1)]
	
func fare_prompt() -> void:
	amt = random_plite()
	label_plite.text = str(amt)
	fare_display.visible = true
	


func plite_timeout() -> void:
	timer.wait_time = randf_range(1.00, 5.00)
	timer.one_shot = true
	timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sprites = {
			PassengerType.MALE : {
				"sit" : male_sit,
				"stand" : male_stand
			},
			PassengerType.FEMALE : {
				"sit" : female_sit,
				"stand" : female_stand
			},
			PassengerType.F_OLD: {
				"sit" : old_sit,
				"stand" : old_stand
			},
			PassengerType.M_OLD : {
				"sit" : M_old_sit,
				"stand" : M_old_stand
			}
	}
	generate_random_passenger_type()
	passenger_sprite.texture = sprites[type_chosen]["stand"]
	passenger_sprite.scale = Vector2(0.5, 0.5)
	print("ready pass")
	print(self)
	btn.show()
	full.hide()
	fare_display.visible = false


func go_in(seat_idx: int) -> void:
	btn.hide()
	passenger_sprite.texture = sprites[type_chosen]["sit"]
	if seat_idx > 7:
		passenger_sprite.flip_h = true

func generate_random_passenger_type():
	type_chosen =  PassengerType.values().pick_random()
	if type_chosen == PassengerType.M_OLD or type_chosen == PassengerType.F_OLD:
		regular_track_local = false
	else:
		regular_track_local = true

func show_full() -> void:
	btn.hide()
	full.show()

func _on_texture_button_pressed() -> void:
	print("emitting pickup")
	print(GameManager.is_regular)
	transfer_me.emit(self)
	
func _on_timer_timeout() -> void:
	fare_prompt()
	
func _on_fare_b_pressed() -> void:
	GameManager.accommodate_fare.emit(amt, regular_track_local, self)
	print("emitted amt: ", amt, regular_track_local)

func change_recv() -> void:
	self.remove_child(fare_display)
	dropoff_timer.wait_time = randf_range(2.00, 4.00)
	dropoff_timer.one_shot = true
	dropoff_timer.start()
	
func _on_timer_dropoff_timeout() -> void:
	self.queue_free()
