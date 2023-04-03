extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move_to = null
var health = 7
var infected: bool = false
var can_climb = false

signal hit_player(damage: int)

func _ready():
	if not SceneTransition.is_player:
		var initial = self.global_position
		self.global_position = $%Cultist.global_position
		$%Cultist.queue_free()
		$AnimatedSprite2D.play("cultist")
		$AnimatedSprite2D.flip_h = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", Vector2(-100, 25), 2)
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 5.
		timer.one_shot = true
		timer.timeout.connect(back_to_menu)
		timer.start()
		
		
func back_to_menu():
	SceneTransition.spawnpoint = null
	SceneTransition.is_player = true
	SceneTransition.change_scene("res://Menu.tscn")

func _physics_process(delta):
	if not SceneTransition.is_player:
		return
	
	# Add the gravity.
	if not is_on_floor() and not can_climb:
		velocity.y += gravity * delta
	else:
		if Input.is_key_pressed(PlayerKeymap.get_key("up")) and not infected:
			if can_climb:
				velocity.y = -100
			else:
				velocity.y = JUMP_VELOCITY
				$AnimatedSprite2D.play("jump")
		elif Input.is_key_pressed(PlayerKeymap.get_key("down")) and not infected:
			if can_climb: 
				velocity.y = 100
			else: 
				global_position.y += 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = null
	if infected:
		direction = 1
	else:
		direction = (Input.is_key_pressed(PlayerKeymap.get_key("right")) as int) - (Input.is_key_pressed(PlayerKeymap.get_key("left")) as int)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if abs(velocity.x) > 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if is_on_floor():
		$AnimatedSprite2D.play("walking" if abs(velocity.x) > 0 else "idle")
		
	# Raycast to allow for walking up small steps
	#if abs(velocity.length()) > 0:
	if false:
		var space_state = PhysicsServer2D.space_get_direct_state(get_world_2d().space)
		
		# 0 when facing left, 1 when facing right
		var facing = (sign(velocity.x) + 1) / 2
		var player_collider_rect = $CollisionShape2D.shape.get_rect()
		
		var from = player_collider_rect.position + Vector2(facing * (player_collider_rect.size.x + 3), player_collider_rect.size.y / 2)
		var to = player_collider_rect.position + Vector2(facing * (player_collider_rect.size.x + 3), player_collider_rect.size.y + 20)
		var ray_above = PhysicsRayQueryParameters2D.create(from, to, 0xFFFFFFFF, [self])
		
		$Line2D.points = []
		#Vector2(facing*half_collider_width + 2, 0)
		$Line2D.add_point(from)
		$Line2D.add_point(to)
		
		var intersect_above = space_state.intersect_ray(ray_above)
		print(intersect_above)
		
		if intersect_above.has("collider") and is_on_floor():
			var tween = get_tree().create_tween()
			var step_delta = intersect_above["position"] - (player_collider_rect.position + player_collider_rect.size / 2)
			#step_target.y -= 2
			tween.tween_property(self, "global_position", global_position + step_delta, .1)
	
	move_and_slide()

func _process(delta):
	if not SceneTransition.is_player:
		return
	
	var e_pressed = Input.is_key_pressed(PlayerKeymap.get_key("enter"))
	if e_pressed and can_move_to and SceneTransition.unlocked_door:
		SceneTransition.change_scene(can_move_to)
	
func _on_doorway_enter(body, doorway_location):
	can_move_to = doorway_location

func _on_doorway_exit(body):
	can_move_to = null


func _animation_finished():
	if $AnimatedSprite2D.animation == "jump":
		$AnimatedSprite2D.stop()

func _on_portal_entered(body, portal_location):
	if body.is_in_group("Player"):
		SceneTransition.change_scene(portal_location)

func _on_hit_player(damage):
	health -= damage
	# Some anim here

func infect():
	infected = true
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0.4, 1), 1)
	$ClearInfectionTimer.start()
	CanvasItem
	
func deal_damage(damage: int, knockback: float):
	health -= damage
	velocity.x = knockback
	velocity.y = JUMP_VELOCITY / 3
	move_and_slide()
	print(health)

func _on_ClearInfectionTimer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 1)
	infected = false

func _on_ladder_body_entered(body):
	if body.is_in_group("Player"):
		can_climb = true


func _on_ladder_body_exited(body):
	if body.is_in_group("Player"):
		can_climb = false
