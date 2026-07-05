extends Node2D

const GRID_SIZE = 20
const GRID_WIDTH = 30
const GRID_HEIGHT = 30

var pos: Vector2 = Vector2.ZERO

func _ready():
	pass

func _draw():
	# Draw the food as a red square
	draw_rect(Rect2(pos, Vector2(GRID_SIZE - 1, GRID_SIZE - 1)), Color.RED)

func spawn():
	var snake = get_parent().get_node("Snake")
	var occupied: Array = snake.segments

	for _i in range(1000):
		var candidate = Vector2(
			randi() % GRID_WIDTH * GRID_SIZE,
			randi() % GRID_HEIGHT * GRID_SIZE
		)
		var free = true
		for seg in occupied:
			if candidate == seg:
				free = false
				break
		if free:
			pos = candidate
			break

	queue_redraw()
