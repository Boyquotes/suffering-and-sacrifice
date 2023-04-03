extends Area2D
var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not SceneTransition.is_player:
		self.visible = false
	else:
		var walk_in = get_tree().create_tween()
		walk_in.tween_property(self, "global_position", Vector2(-100, 25), 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(PlayerKeymap.get_key("enter")) and player_in_range and not $%DialogueBox.in_dialogue:
		$%DialogueBox.start_dialogue()

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
