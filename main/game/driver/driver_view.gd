extends Node2D

@onready var money_manager: Control = $UI/MoneyManager
@onready var texture_button: TextureButton = $UI/TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money_manager.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	texture_button.hide()
	money_manager.show()
