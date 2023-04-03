extends CanvasLayer

var spawnpoint = null
var is_player = true
var unlocked_door = false

func change_scene(target: String, spawnpoint = null) -> void:
	$AnimationPlayer.play('fade_in')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	self.spawnpoint = spawnpoint
	$AnimationPlayer.play_backwards('fade_in')
