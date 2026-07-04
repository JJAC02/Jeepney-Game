extends Node2D

signal transfer_me(inst: Node2D)

@onready var btn: TextureButton = $TextureButton
@onready var full: Sprite2D = $full
@onready var passenger_sprite: Sprite2D = $passenger_type
@onready var label_plite: Label = $fareDisplay/fareBG/Label
@onready var fare_display: Node2D = $fareDisplay
@onready var timer: Timer = $fareDisplay/Timer

@export var male_stand: Texture2D 
@export var male_sit: Texture2D 
@export var female_stand: Texture2D
@export var female_sit: Texture2D 
@export var old_stand: Texture2D
@export var old_sit: Texture2D 

enum PassengerType {
	MALE, 
	FEMALE,
	OLD
}

var type_chosen : PassengerType
var sprites := {}
func random_plite() -> int:
	var plite : Array[int] = [14, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100]
	
	return plite[randi_range(0, (plite.size())-1)]
	
func fare_prompt() -> void:
	var amt := random_plite()
	GameManager.fare_received = amt
	label_plite.text = str(amt)
	fare_display.visible = true
	

func plite_timeout() -> void:
	timer.wait_time = randf_range(2.00, 10.00)
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
			PassengerType.OLD : {
				"sit" : old_sit,
				"stand" : old_stand
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
	if type_chosen == PassengerType.OLD:
		GameManager.is_regular = false
	else:
		GameManager.is_regular = true

func show_full() -> void:
	btn.hide()
	full.show()

func _on_texture_button_pressed() -> void:
	print("emitting pickup")
	print(GameManager.is_regular)
	transfer_me.emit(self)
	
func _on_timer_timeout() -> void:
	fare_prompt()
	
