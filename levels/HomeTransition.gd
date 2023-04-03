extends Area2D

func _on_home_portal_entered(body):
	if body.is_in_group("Player"):
		SceneTransition.is_player = false
		SceneTransition.change_scene("res://levels/Level1.tscn")

func _on_level_4_portal_body_entered(body):
	if body.is_in_group("Player"):
		SceneTransition.change_scene("res://levels/Level4.tscn", "%LadderSpawn")
