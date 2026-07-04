extends Node2D

# 3 lanes (js for practice make this 2 nalang later)
enum Lane { LEFT, CENTER, RIGHT }
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

var current_lane: Lane = Lane.CENTER
var score: int = 0
var is_game_over: bool = false

#preload loads resources at script runtime for smooth gameplay instead of fetching on the line obstacle actually spawns
@onready var obstacle_scene = preload("res://main/game/driver/Obstacle.tscn")
@onready var obstacle_container = $ObstacleContainer #group obstacles to easily manage z-index n other configs if ever
@onready var spawn_timer = $SpawnTimer 
@onready var score_label = $UI/ScoreLabel

# money manager
@onready var money_manager: Control = $UI/MoneyManager
@onready var texture_button: TextureButton = $UI/TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money_manager.hide()
	setup_input_actions(); 
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	update_score_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func setup_input_actions() -> void:
	# MOVE LEFT (use new so two keybinds same fx don't overwrite each other) 
	InputMap.add_action("move_left") 
	var event = InputEventKey.new() 
	event.keycode = KEY_LEFT
	InputMap.action_add_event("move_left", event)
	event = InputEventKey.new() 
	event.keycode = KEY_A
	InputMap.action_add_event("move_left", event)
	
	# MOVE RIGHT 
	InputMap.add_action("move_right") 
	event = InputEventKey.new() 
	event.keycode = KEY_RIGHT
	InputMap.action_add_event("move_right", event)
	event = InputEventKey.new() 
	event.keycode = KEY_D
	InputMap.action_add_event("move_right", event)

func _input(event: InputEvent) -> void: #trigger whenever there's actual input
	if is_game_over:
		return #uhhh not too sure abt this i forgot
	if event.is_action_pressed("move_left"):
		move_left()
	elif event.is_action_pressed("move_right"):
		move_right()

func move_right() -> void: 
		if current_lane < Lane.RIGHT:
			current_lane += 1
			animate_lane_shift() #no sprites for this pa
			
func move_left() -> void:
	if current_lane > Lane.LEFT:
		current_lane -= 1
		animate_lane_shift()
	
func _on_spawn_timer_timeout() -> void:
	var random_lane = [Lane.LEFT, Lane.CENTER, Lane.RIGHT].pick_random()
	var obstacle = obstacle_scene.instantiate()
	obstacle_container.add_child(obstacle)
	obstacle.reached_windshield.connect(_on_obstacle_reached_windshield)
	obstacle.setup(random_lane, 0.8)

func _on_obstacle_reached_windshield(obstacle_lane: int) -> void:
	if obstacle_lane == current_lane:
		trigger_game_over()
	else:
		add_score(10)

func add_score(amount: int) -> void:
	score += amount
	update_score_display()

func animate_lane_shift() -> void:
	# placeholder — will drive AnimatedSprite2D later
	pass

func update_score_display() -> void:
	if score_label:
		score_label.text = "Score: " + str(score)

func trigger_game_over() -> void:
	is_game_over = true
	GameManager.game_over.emit(score)
	get_tree().paused = true

func _on_texture_button_pressed() -> void:
	texture_button.hide()
	money_manager.show()

func _on_hide_money_manager() -> void:
	money_manager.hide()
	texture_button.show()
