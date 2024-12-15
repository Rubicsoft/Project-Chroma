extends CharacterBody2D
class_name Player

@onready var dash_cooldown: Timer = $Timer/DashCooldown

@export var player_camera: Camera2D
@export var camera_pivot: Node2D

@export var speed: float = 30.0
@export var jump_velocity: float = 16.0
# Dashing variables
@export var dash_multiplier: float = 40.0
@export var dash_times: int = 3

var player_direction: float
var cam_follow: bool = true

func _process(delta) -> void:
	camera_follows_player(cam_follow, delta)

func _input(event) -> void:
	if Global.player_controllable:
		jump(event)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 5.0 * delta

	if Global.player_controllable:
		player_direction = Input.get_axis("move_left", "move_right")
		if player_direction:
			velocity.x = player_direction * speed * 1000.0 * delta
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		start_dash(delta)
		if dash_times <= 0:
			dash_cooldown.start()
			print("TIMEOUT")
	
	move_and_slide()

# Handle jump
func jump(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity * 100.0
		print("JUMP")

# Make the camera follows the player
func camera_follows_player(is_following: bool, delta: float) -> void:
	if is_following and camera_pivot:
		camera_pivot.global_position = lerp(camera_pivot.global_position, global_position, 8.0 * delta)

# Handle dashing
func start_dash(delta: float) -> void:
	if Input.is_action_just_pressed("dash") and dash_times > 0:
		print("DASH")
		if player_direction:
			velocity.x = player_direction * speed * dash_multiplier * 1000.0 * delta
			dash_times -= 1
			print("Dash times : " + str(dash_times))

func _on_dash_cooldown_timeout():
	dash_times = 3
	print("RESET")
