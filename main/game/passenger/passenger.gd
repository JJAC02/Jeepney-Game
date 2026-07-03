extends Node2D

signal transfer_me()

@onready var btn: TextureButton = $TextureButton
@onready var full: Sprite2D = $full
@onready var parapo: Sprite2D = $paraPo
@onready var sitting: Sprite2D = $sitting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready pass")
	btn.show()
	sitting.hide()
	full.hide()


func go_in(seat_idx: int) -> void:
	btn.hide()
	parapo.hide()
	if seat_idx > 7:
		sitting.flip_h = true
	sitting.show()

func show_full() -> void:
	btn.hide()
	full.show()

func _on_texture_button_pressed() -> void:
	print("emitting pickup")
	transfer_me.emit()
