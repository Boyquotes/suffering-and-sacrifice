extends CharacterBody2D

const SPEED = 40
const JUMP_VELOCITY = -150
const Player = preload("res://Player.gd")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var should_jump: bool = false
var jump_left = false
var can_hurt = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if is_on_floor():
		if should_jump:
			should_jump = false
			velocity.y = JUMP_VELOCITY
			if jump_left:
				velocity.x = -SPEED
			else:
				velocity.x = SPEED
			jump_left = !jump_left
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_jump_timer_timeout():
	should_jump = true

func _on_player_detection_area_body_entered(body):
	print(body.get_groups())
	if body.is_in_group("Player"):
		
		body.deal_damage(1, global_position.x - body.global_position)
		can_hurt = false
		
func _on_player_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		can_hurt = true
