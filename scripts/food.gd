extends Node2D

const GRID_SIZE = 20
const GRID_WIDTH = 30
const GRID_HEIGHT = 30

var food: ColorRect = null

func _ready():
	pass

func spawn_food():
	if food:
		food.queue_free()
	
	food = ColorRect.new()
	food.size = Vector2(GRID_SIZE - 1, GRID_SIZE - 1)
	food.color = Color.RED
	add_child(food)
	
	randomize_position()

func randomize_position():
	var snake = get_parent().get_node("Snake")
	var body_positions = snake.get_body_positions()
	
	var pos: Vector2
	var max_attempts = 1000
	var attempts = 0
	
	while true:
		pos = Vector2(
			randi() % GRID_WIDTH * GRID_SIZE,
			randi() % GRID_HEIGHT * GRID_SIZE
		)
		
		var occupied = false
		for body_pos in body_positions:
			if pos == body_pos:
				occupied = true
				break
		
		if not occupied:
			break
		
		attempts += 1
		if attempts >= max_attempts:
			break
	
	food.position = pos

func get_food_position() -> Vector2:
	return food.position if food else Vector2(-GRID_SIZE, -GRID_SIZE)
