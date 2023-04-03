extends CharacterBody2D

const SPEED = 100
const DETECTION_DISTANCE = 60

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum {IDLE, HOVERING, ATTACKING}
var state = IDLE
var should_attack = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func calculate_deficit(ray: RayCast2D) -> float:
	var target_position = ray.global_position + ray.target_position
	if ray.is_colliding():
		return ray.get_collision_point().y - target_position.y
	else:
		return 1

func maintain_height():
	velocity.y += (calculate_deficit($RayLeft) + calculate_deficit($RayRight)) / 2

func _physics_process(delta):
	var player_position = $%Player.global_position
	var self_position = global_position
	var horizontal_delta = player_position.x - self_position.x
	
	if should_attack and state == HOVERING:
		should_attack = false
		state = ATTACKING
	
	match state:
		ATTACKING: 
			velocity = player_position - self_position
			var player_collider_id = $%Player/CollisionShape2D.get_instance_id()
			for i in get_slide_collision_count():
				var collider_id = get_slide_collision(i).get_collider_id()
				if collider_id == player_collider_id:
					state = HOVERING
					print("PlayerHit")
					
		HOVERING:
			maintain_height()
			if abs(horizontal_delta) > DETECTION_DISTANCE:
				state = IDLE
			else:
				velocity.x = horizontal_delta
		IDLE:
			maintain_height()
			if abs(horizontal_delta) <= DETECTION_DISTANCE:
				state = HOVERING
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.x = clampf(velocity.x, -SPEED, SPEED)
	velocity.y = move_toward(velocity.y, 0, delta * 3)
	if abs(velocity.x) > 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	should_attack = true
