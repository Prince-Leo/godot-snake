extends Node2D

const GRID_SIZE = 20
const GRID_WIDTH = 30
const GRID_HEIGHT = 30

@onready var snake = $Snake
@onready var food = $Food
@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var move_timer = $MoveTimer

var score: int = 0
var game_over: bool = false

func _ready():
	# CRITICAL FIX: Connect the timer signal
	move_timer.timeout.connect(_on_move_timer_timeout)
	start_game()

func _draw():
	# Gray-white checkerboard background
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var color = Color(0.75, 0.75, 0.75, 1) if (x + y) % 2 == 0 else Color(0.9, 0.9, 0.9, 1)
			draw_rect(Rect2(x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE), color)

func start_game():
	score = 0
	game_over = false
	game_over_label.visible = false
	update_score()
	snake.reset()
	food.spawn()
	move_timer.wait_time = 0.15
	move_timer.start()
	queue_redraw()

func _on_move_timer_timeout():
	if game_over:
		return
	snake.move()
	check_collisions()

func check_collisions():
	var head = snake.get_head_pos()

	# Check wall collision
	if head.x < 0 or head.x >= GRID_WIDTH * GRID_SIZE or \
	   head.y < 0 or head.y >= GRID_HEIGHT * GRID_SIZE:
		end_game()
		return

	# Check self collision
	if snake.collides_with_self():
		end_game()
		return

	# Check food collision
	if head == food.pos:
		score += 1
		update_score()
		snake.grow()
		food.spawn()
		move_timer.wait_time = max(0.05, move_timer.wait_time - 0.002)

func end_game():
	game_over = true
	game_over_label.visible = true
	move_timer.stop()

func _input(event):
	if game_over and event.is_action_pressed("ui_accept"):
		start_game()

func update_score():
	score_label.text = "Score: %d" % score
