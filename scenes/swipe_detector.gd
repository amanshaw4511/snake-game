extends Node

@export var min_swipe_distance := 50.0  # Minimum distance in pixels to qualify as a swipe

signal swipe(direction: String)

var swipe_start := Vector2()
var swipe_end := Vector2()
var is_swiping := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.position
			is_swiping = true
		else:
			swipe_end = event.position
			if is_swiping:
				_detect_swipe()
			is_swiping = false

	elif event is InputEventMouseButton and event.pressed:
		# Optional: support mouse for desktop debugging
		swipe_start = event.position
		is_swiping = true

	elif event is InputEventMouseButton and not event.pressed:
		swipe_end = event.position
		if is_swiping:
			_detect_swipe()
		is_swiping = false

func _detect_swipe() -> void:
	var delta := swipe_end - swipe_start
	if delta.length() < min_swipe_distance:
		return  # Swipe too short to register

	if abs(delta.x) > abs(delta.y):
		if delta.x > 0:
			print("Swipe Right")
			_on_swipe("right")
		else:
			print("Swipe Left")
			_on_swipe("left")
	else:
		if delta.y > 0:
			print("Swipe Down")
			_on_swipe("down")
		else:
			print("Swipe Up")
			_on_swipe("up")

func _on_swipe(direction: String) -> void:
	# Replace this with your game logic
	swipe.emit(direction)
