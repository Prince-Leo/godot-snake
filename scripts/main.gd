extends Node2D

const GRID_SIZE = 20
const GRID_WIDTH = 30
const GRID_HEIGHT = 30

@onready var snake = $Snake
@onready var food_spawner = $FoodSpawner
@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var move_timer = $MoveTimer

var score: int = 0
var game_over: bool = false

func _ready():
	start_game()

func start_game():
	score = 0
	game_over = false
	game_over_label.visible = false
	update_score()
	snake.reset()
	food_spawner.spawn_food()
	move_timer.start()

func _on_move_timer_timeout():
	if game_over:
		return
	snake.move()
	check_collision()

func check_collision():
	var head_pos = snake.get_head_position()
	
	# Check wall collision
	if head_pos.x < 0 or head_pos.x >= GRID_WIDTH * GRID_SIZE or \
	   head_pos.y < 0 or head_pos.y >= GRID_HEIGHT * GRID_SIZE:
		on_game_over()
		return
	
	# Check self collision
	var body_positions = snake.get_body_positions()
	for i in range(1, body_positions.size()):
		if head_pos == body_positions[i]:
			on_game_over()
			return
	
	# Check food collision
	if head_pos == food_spawner.get_food_position():
		on_food_eaten()

func on_food_eaten():
	score += 1
	update_score()
	snake.grow()
	food_spawner.spawn_food()
	# Speed up slightly
	move_timer.wait_time = max(0.05, move_timer.wait_time - 0.002)

func on_game_over():
	game_over = true
	game_over_label.visible = true
	move_timer.stop()

func _input(event):
	if game_over and event.is_action_pressed("ui_accept"):
		move_timer.wait_time = 0.15
		start_game()

func update_score():
	score_label.text = "Score: %d" % score
