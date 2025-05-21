extends Node

@export var snake_scene: PackedScene

var game_started: bool

const cells: int = 10 # no of  cell in rows and colums
const cell_size: int = 50 # in pixel


# snake variables
var old_data: Array
var snake_data: Array[Vector2] = []
var snake : Array

# movement

const start_pos_unit: int = floor(cells / 2) -1
const start_pos = Vector2(start_pos_unit, start_pos_unit)
var move_dir: Vector2
var can_move: bool

	

func _ready() -> void:
	new_game()

	
func new_game() -> void:
	self.get_tree().call_group("segment_group", "queue_free") # clear all snake segmemts
	$GameOverMenu.hide()
	$ScorePanel.reset_score()
	can_move = true
	move_dir = Vector2.UP
	print("debug")
	
	old_data.clear()
	snake_data.clear()
	snake.clear()
	
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))
	
	regen_food()

func add_segment(pos: Vector2):
	var SnakeSegment = snake_scene.instantiate()
	set_position(SnakeSegment, pos)
	
	self.snake_data.append(pos)
	self.snake.append(SnakeSegment)
	self.add_child(SnakeSegment)
	

func set_position(segment, pos: Vector2):
	segment.position = (pos * cell_size)  + Vector2(0, cell_size)
	
func _process(_delta: float) -> void:
	handle_input()
	

func handle_input():
	if !can_move:
		return
	
	if Input.is_action_just_pressed("ui_right"):
		handle_direction(Vector2.RIGHT)
	
	if Input.is_action_just_pressed("ui_left"):
		handle_direction(Vector2.LEFT)
		
	if Input.is_action_just_pressed("ui_down"):
		handle_direction(Vector2.DOWN)
		
	if Input.is_action_just_pressed("ui_up"):
		handle_direction(Vector2.UP)


func handle_direction(direction: Vector2):
	if direction == - move_dir: # not allow left if current dir is right, etc
		return
	
	move_dir = direction
	can_move = false
	
	if !game_started:
		start_game()


func start_game():
	game_started = true
	$MoveTimer.start()



func _on_move_timer_timeout() -> void:
	can_move = true
	move_snake()
	
	handle_out_of_bound()
	handle_self_eaten()
	handle_food_eaten()


func move_snake():
	old_data = [] + snake_data
	snake_data[0] += move_dir
	for i in range(len(snake_data)):
		if i > 0:
			snake_data[i] = old_data[i - 1]
		set_position(snake[i], snake_data[i])


func handle_out_of_bound():
	var snake_head: Vector2 = snake_data[0]
	if snake_head.x < 0 or snake_head.y < 0 or snake_head.x > cells-1 or snake_head.y > cells-1:
		end_game()


func handle_self_eaten():
	var snake_head = snake_data[0]
	for i in range(1, len(snake_data)):
		if snake_data[i] == snake_head:
			end_game()


func handle_food_eaten():
	var snake_head = snake_data[0]
	if snake_head != $Food.food_pos:
		return

	$ScorePanel.increment_score()
	regen_food()
	add_segment(old_data[-1])


func gen_food_pos():
	return Vector2(randi_range(0, cells-1), randi_range(0, cells -1))

func pos_in_snake(pos: Vector2):
	for segment in snake_data:
		if segment == pos:
			return true
	return false


func regen_food():
	while true:
		$Food.food_pos = gen_food_pos()
		if not pos_in_snake($Food.food_pos):
			break
	set_position($Food, $Food.food_pos)


func end_game():
	game_started = false
	$GameOverMenu.show()
	$MoveTimer.stop()


func _on_game_over_menu_restart() -> void:
	new_game()


func _on_swipe_detector_swipe(direction: String) -> void:
	if !can_move:
		return
	
	if direction == "down":
		handle_direction(Vector2.DOWN)
	if direction == "up":
		handle_direction(Vector2.UP)
	if direction == "left":
		handle_direction(Vector2.LEFT)
	if direction == "right":
		handle_direction(Vector2.RIGHT)
	
