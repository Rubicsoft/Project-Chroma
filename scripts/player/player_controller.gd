extends CharacterBody2D

@export var player_camera: Camera2D
@export var camera_pivot: Node2D

@export var speed = 30.0
@export var jump_velocity = 16.0

func _process(delta):
	camera_follows_player(true, delta)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 5.0 * delta

	if Global.player_controllable:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump_velocity * 100.0

		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed * 1000.0 * delta
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

# Make the camera follows the player
func camera_follows_player(is_following: bool, delta: float):
	if is_following and camera_pivot:
		camera_pivot.global_position = lerp(camera_pivot.global_position, global_position, 8.0 * delta)
