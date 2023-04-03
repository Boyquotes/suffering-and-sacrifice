extends Control

func _on_button_pressed():
	SceneTransition.change_scene("res://levels/Level1.tscn")

func position_cultists():
	var window_size = get_tree().get_root().size
	$LeftCultist.global_position = Vector2(182, window_size.y/2)
	$RightCultist.global_position = Vector2(window_size.x - $LeftCultist.global_position.x, window_size.y/2)

func _ready():
	position_cultists()
	get_tree().get_root().size_changed.connect(resized)
	
func resized():
	position_cultists()
