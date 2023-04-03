extends Node2D

# Called when the node enters the scene tree for the first time.
func adjust_camera():
	var shape =  $MapArea/CollisionShape2D.shape.get_rect()
	var viewport_height = get_tree().get_root().size.y
	var scale = viewport_height / shape.size.y
	
	$%Player/Camera2D.zoom = Vector2(scale, scale)
	$%Player/Camera2D.limit_left = shape.position.x
	$%Player/Camera2D.limit_right = shape.end.x
	$%Player/Camera2D.limit_top = shape.position.y
	$%Player/Camera2D.limit_bottom = shape.end.y

func _ready():
	adjust_camera()
	get_tree().get_root().size_changed.connect(resized)
	
	# Set spawnpoint
	if SceneTransition.spawnpoint:
		var spawn = get_node(SceneTransition.spawnpoint).global_position
		$%Player.global_position = spawn
		SceneTransition.spawnpoint = null

func resized():
	adjust_camera()
