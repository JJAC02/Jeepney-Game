extends Area2D

enum Lane { LEFT, CENTER, RIGHT }

signal reached_windshield(obstacle_lane: int)

@export var speed: float = 1.0
var current_lane: Lane = Lane.CENTER
var progress: float = 0.0

var start_positions = {
	Lane.LEFT: Vector2(620, 320),
	Lane.CENTER: Vector2(640, 320),
	Lane.RIGHT: Vector2(660, 320)
}

var end_positions = {
	Lane.LEFT: Vector2(200, 720),
	Lane.CENTER: Vector2(640, 720),
	Lane.RIGHT: Vector2(1080, 720)
}

func setup(lane: Lane, approach_speed: float) -> void:
	current_lane = lane
	speed = approach_speed
	progress = 0.0
	scale = Vector2(0.05, 0.05)
	update_obstacle_transform()

func _draw() -> void:
	draw_rect(Rect2(-15, -15, 30, 30), Color(1, 0.2, 0.2))
	draw_rect(Rect2(-12, -12, 24, 24), Color(1, 0.4, 0.4))

func _process(delta: float) -> void:
	progress += speed * delta
	if progress >= 1.0:
		reached_windshield.emit(current_lane)
		queue_free()
		return
	update_obstacle_transform()

func update_obstacle_transform() -> void:
	var start = start_positions[current_lane]
	var end = end_positions[current_lane]
	global_position = start.lerp(end, progress)
	var scale_factor = lerp(0.05, 1.2, progress * progress)
	scale = Vector2(scale_factor, scale_factor)
