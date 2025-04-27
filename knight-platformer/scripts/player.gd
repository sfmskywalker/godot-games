extends CharacterBody2D

const SPEED = 130.0
const BUTTON_LEFT = 1
const JUMP_VELOCITY = -300.0
var touch_start_position = Vector2()
var swipe_threshold = 50
var is_dragging = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_position = event.position
			is_dragging = false
		else:
			if not is_dragging:
				_simulate_input("jump")
			Input.action_release("move_left")
			Input.action_release("move_right")

	elif event is InputEventScreenDrag:
		is_dragging = true
		var swipe_distance = event.position.x - touch_start_position.x
		if swipe_distance > swipe_threshold:
			Input.action_press("move_right")
			Input.action_release("move_left")
		elif swipe_distance < -swipe_threshold:
			Input.action_press("move_left")
			Input.action_release("move_right")
		else:
			Input.action_release("move_left")
			Input.action_release("move_right")

	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			touch_start_position = event.position
			is_dragging = false
		else:
			if not is_dragging:
				_simulate_input("jump")
			Input.action_release("move_left")
			Input.action_release("move_right")

	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT):
		is_dragging = true
		var swipe_distance = event.position.x - touch_start_position.x
		if swipe_distance > swipe_threshold:
			Input.action_press("move_right")
			Input.action_release("move_left")
		elif swipe_distance < -swipe_threshold:
			Input.action_press("move_left")
			Input.action_release("move_right")
		else:
			Input.action_release("move_left")
			Input.action_release("move_right")

func _simulate_input(action_name: String) -> void:
	Input.action_press(action_name)
	call_deferred("_release_action", action_name)

func _release_action(action_name: String) -> void:
	Input.action_release(action_name)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		animated_sprite.play("idle" if direction == 0 else "run")
	else:
		animated_sprite.play("jump")

	velocity.x = direction * SPEED if direction != 0 else move_toward(velocity.x, 0, SPEED)
	move_and_slide()
