extends Camera2D

@export var shake_speed: float = 15.0      # How fast the camera vibrates
@export var shake_amplitude: float = 4.0  # Max distance in pixels the camera moves

var noise : FastNoiseLite = FastNoiseLite.new()
var noise_time: float = 0.0

func _ready() -> void:
	# Initialize the noise generator for smooth random motion
	noise.seed = randi()
	noise.frequency = 0.5
	noise.fractal_octaves = 2

func _process(delta: float) -> void:
	# Advance time to scan through the noise map
	noise_time += delta * shake_speed
	
	# Sample different noise coordinates for X and Y axes
	var shake_offset_x = noise.get_noise_1d(noise_time) * shake_amplitude
	var shake_offset_y = noise.get_noise_1d(noise_time + 100.0) * shake_amplitude
	
	# Apply directly to the camera's built-in offset property
	offset = Vector2(shake_offset_x, shake_offset_y)
