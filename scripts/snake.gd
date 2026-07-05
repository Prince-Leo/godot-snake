extends Node2D

const GRID_SIZE = 20
const GRID_WIDTH = 30
const GRID_HEIGHT = 30

var body_segments: Array = []
var direction: Vector2 = Vector2.RIGHT
var last_direction: Vector2 = Vector2.RIGHT
var growing: bool = false

signal food_eaten
signal game_over

func _ready():
	reset()

func reset():
	# Clear existing segments
	for segment in body_segments:
		segment.queue_free()
	body_segments.clear()
	
	# Create initial 3 segments
	for i in range(3):
		var segment = create_segment()
		segment.position = Vector2(GRID_WIDTH / 2 - i, GRID_HEIGHT / 2) * GRID_SIZE
		body_segments.append(segment)
	
	direction = Vector2.RIGHT
	last_direction = Vector2.RIGHT
	growing = false

func create_segment() -> ColorRect:
	var segment = ColorRect.new()
	segment.size = Vector2(GRID_SIZE - 1, GRID_SIZE - 1)
	segment.color = Color.GREEN
	add_child(segment)
	return segment

func _input(event):
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
	
	var head_pos = body_segments[0].position
	var new_head_pos = head_pos + direction * GRID_SIZE
	
	# Shift body: each segment takes the position of the one before it
	for i in range(body_segments.size() - 1, 0, -1):
		body_segments[i].position = body_segments[i - 1].position
	
	# Move head to new position
	body_segments[0].position = new_head_pos
	
	# Grow if needed
	if growing:
		var new_segment = create_segment()
		new_segment.position = body_segments[body_segments.size() - 1].position
		body_segments.append(new_segment)
		growing = false

func grow():
	growing = true

func get_head_position() -> Vector2:
	return body_segments[0].position if body_segments.size() > 0 else Vector2.ZERO

func get_body_positions() -> Array:
	var positions: Array = []
	for segment in body_segments:
		positions.append(segment.position)
	return positions
