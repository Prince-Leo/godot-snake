extends Node2D

const GRID_SIZE = 20
const GRID_WIDTH = 30
const GRID_HEIGHT = 30

var segments: Array[Vector2] = []
var direction: Vector2 = Vector2.RIGHT
var last_direction: Vector2 = Vector2.RIGHT
var grow_next: bool = false

func _ready():
	reset()

func reset():
	segments.clear()
	# Start with 3 segments in the center, heading right
	for i in range(3):
		segments.append(Vector2(GRID_WIDTH / 2.0 - i, GRID_HEIGHT / 2.0) * GRID_SIZE)
	direction = Vector2.RIGHT
	last_direction = Vector2.RIGHT
	grow_next = false
	queue_redraw()

func _draw():
	# Draw each body segment as a green square
	for pos in segments:
		draw_rect(Rect2(pos, Vector2(GRID_SIZE - 1, GRID_SIZE - 1)), Color.GREEN)

func _input(event):
	# Direction input: prevent 180° reversal
	if event.is_action_pressed("move_up") and last_direction != Vector2.DOWN:
		direction = Vector2.UP
	elif event.is_action_pressed("move_down") and last_direction != Vector2.UP:
		direction = Vector2.DOWN
	elif event.is_action_pressed("move_left") and last_direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif event.is_action_pressed("move_right") and last_direction != Vector2.LEFT:
		direction = Vector2.RIGHT

func move():
	last_direction = direction
	var new_head = segments[0] + direction * GRID_SIZE

	# Insert new head at the front
	segments.insert(0, new_head)

	# Remove tail unless we're growing
	if not grow_next:
		segments.pop_back()
	else:
		grow_next = false

	queue_redraw()

func grow():
	grow_next = true

func get_head_pos() -> Vector2:
	return segments[0] if segments.size() > 0 else Vector2.ZERO

func collides_with_self() -> bool:
	var head = segments[0]
	for i in range(1, segments.size()):
		if head == segments[i]:
			return true
	return false
