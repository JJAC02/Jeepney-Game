extends Node2D

var scroll_offset: float = 0.0
var dash_length: float = 40.0
var gap_length: float = 30.0
var scroll_speed: float = 200.0

func _ready() -> void:
	if get_viewport():
		get_viewport().size_changed.connect(queue_redraw)

func _process(delta: float) -> void:
	scroll_offset += scroll_speed * delta
	if scroll_offset >= dash_length + gap_length:
		scroll_offset -= dash_length + gap_length
	queue_redraw()

func _draw() -> void:
	var viewport_size = get_viewport_rect().size
	if viewport_size == Vector2.ZERO:
		viewport_size = Vector2(1280, 720)

	var vanish_x = viewport_size.x * 0.5
	var vanish_y = viewport_size.y * 0.45
	var bottom_y = viewport_size.y

	#road surface
	draw_colored_polygon(PackedVector2Array([
		Vector2(vanish_x - 30, vanish_y),
		Vector2(vanish_x + 30, vanish_y),
		Vector2(viewport_size.x * 0.9, bottom_y),
		Vector2(viewport_size.x * 0.1, bottom_y)
	]), Color(0.25, 0.25, 0.25))

	#road shoulders (darker edges)
	draw_colored_polygon(PackedVector2Array([
		Vector2(vanish_x - 35, vanish_y),
		Vector2(vanish_x - 30, vanish_y),
		Vector2(viewport_size.x * 0.1, bottom_y),
		Vector2(viewport_size.x * 0.07, bottom_y),
	]), Color(0.18, 0.18, 0.18))
	draw_colored_polygon(PackedVector2Array([
		Vector2(vanish_x + 30, vanish_y),
		Vector2(vanish_x + 35, vanish_y),
		Vector2(viewport_size.x * 0.93, bottom_y),
		Vector2(viewport_size.x * 0.9, bottom_y),
	]), Color(0.18, 0.18, 0.18))

	#lane divider lines: top (vanish) -> bottom spread points
	var lane_lines = [
		Vector2(vanish_x - 10, vanish_y), Vector2(viewport_size.x * 0.27, bottom_y),
		Vector2(vanish_x, vanish_y),      Vector2(viewport_size.x * 0.5, bottom_y),
		Vector2(vanish_x + 10, vanish_y), Vector2(viewport_size.x * 0.73, bottom_y),
	]

	var lane_color = Color(1, 1, 0.8, 0.5)
	var total_height = bottom_y - vanish_y

	for i in range(0, lane_lines.size(), 2):
		var top = lane_lines[i]
		var bot = lane_lines[i + 1]
		var dy = bot.y - top.y
		var dx = bot.x - top.x
		var dash_count = int(dy / (dash_length + gap_length)) + 2
		var adjusted_offset = fmod(scroll_offset, dash_length + gap_length)

		for d in range(dash_count):
			var t_start = (d * (dash_length + gap_length) + adjusted_offset) / dy
			var t_end = min(t_start + dash_length / dy, 1.0)
			if t_end > 1.0 or t_start > 1.0:
				break
			if t_start < 0.0:
				t_start = 0.0

			var p1 = Vector2(top.x + dx * t_start, top.y + dy * t_start)
			var p2 = Vector2(top.x + dx * t_end, top.y + dy * t_end)
			draw_line(p1, p2, lane_color, 2.0 + (1.0 - t_end) * 3.0)
