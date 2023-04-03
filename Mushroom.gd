extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const Player = preload("res://Player.gd")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Player = null
var infect_within: bool = false

func _process(delta):
	if infect_within:
		infect_within = false
		if player:
			player.infect()

func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		$Particles.emitting = true

func _on_PlayerDetectionZone_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		$Particles.emitting = false

func _on_timer_timeout():
	infect_within = true
