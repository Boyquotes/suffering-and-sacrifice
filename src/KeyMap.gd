extends Node
class_name KeyMap

enum Mode {NONE, SCRAMBLED, MOVING, SCRAMBLED_AND_MOVING}

const ROW = [
	[KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P],
	[KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L],
	[KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M]
]

var map = {
	"up": Vector2i(1,0),
	"down": Vector2i(1,1),
	"left": Vector2i(0,1),
	"right": Vector2i(2,1),
	"enter": Vector2i(2,0),
	"attack": Vector2i(3,1)
}

var shift = 0
var alter_mode = Mode.NONE:
	set(value):
		match value:
			Mode.SCRAMBLED:
				for key in map:
					var rand_row = randi() % 3
					var rand_col = randi() % ROW[rand_row].size()
					map[key] = Vector2i(rand_col, rand_row)
			var mode: 
				alter_mode = mode

func get_key(action: String):
	return _key_from_vector(_apply_mode(map[action]))

func _apply_mode(pos) -> Vector2i:
	match alter_mode:
		Mode.MOVING:
			pos.x = (pos.x + shift) % ROW[pos.y].size()
			return pos
		Mode.SCRAMBLED_AND_MOVING:
			var new_row = randi() % 3
			var new_col = randi() % ROW[new_row].size()
			return Vector2i(new_col, new_row)
		_:
			return pos
	
func _key_from_vector(pos: Vector2i):
	return ROW[pos.y][pos.x]
	
func _input(event):
	# Change upon release
	if event is InputEventKey and not event.pressed:
		shift += 1
	
