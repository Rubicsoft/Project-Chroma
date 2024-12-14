extends CharacterBody2D
class_name Player

@export var player_camera: Camera2D
@export var camera_pivot: Node2D

@export var speed = 40.0
@export var jump_velocity = 16.0

var cam_follow: bool = true

func _process(delta) -> void:
	camera_follows_player(cam_follow, delta)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 5.0 * delta

	if Global.player_controllable:
		# Handle jump.
		jump()

		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed * 1000.0 * delta
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		# Handle dash
		
	
	move_and_slide()

# Handle jump
func jump() -> void:
	# Double jump tracking
	var jump_available: int = 2
	var is_jumping: bool = false
	
	if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity * 100.0
			

# Make the camera follows the player
func camera_follows_player(is_following: bool, delta: float) -> void:
	if is_following and camera_pivot:
		camera_pivot.global_position = lerp(camera_pivot.global_position, global_position, 8.0 * delta)
