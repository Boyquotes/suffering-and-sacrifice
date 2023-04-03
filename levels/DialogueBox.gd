extends MarginContainer

const Mode = preload("res://src/KeyMap.gd").Mode

var line = 0
var in_dialogue = false
var finished = false

const NAME = [
	"Cloaked Figure",
	"Little Pig (Player)",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
	"Cloaked Figure",
]
const TEXT = [
	"Wow bright... Oh. This is familiar.",
	"???",
	"I get it, nevermind. Little thing could I do you the honour of a bargain? Yes? It's decided.",
	"It's very simple all you need to do is choose. I want back something that I lost, something that you have.",
	"In exchange you will be able to enter that house over there and see what lies throughout the different layers of the earth.",
	"The price is your... coordination, mobility, something like that. Point is I'm going to make it much more difficult for you to move.",
	"The more \"mobility\" you give me the stronger I will make you. You will be healthier, stronger, and faster.",
	"There are three sacrifices availible to you: tier 1, 2, and 3 respectively.",
	"In tier 1 your movement controls will constantly moving around but will retain their shape. I'll tell you a secret: the keys are shifted right across the alphabetical keys on the keyboard every time a key is released...",
	"in tier 2 your movement controls will be randomly rearranged...",
	"and in tier 3 (the hardest of the lot) your movement controls will be randomly rearranged every time you enter input. Choose this if you hate yourself."
]

func start_dialogue():
	if !finished:
		self.visible = true
		in_dialogue = true
		next_line()
	

func next_line():
	if line >= len(TEXT):
		return true
	
	$%DialogueName.bbcode_text = NAME[line]
	$%DialogueText.bbcode_text = TEXT[line]
	
	$%DialogueText.visible_characters = 0
	var tween = get_tree().create_tween()
	tween.tween_property($%DialogueText, "visible_characters", len($%DialogueText.text), len($%DialogueText.text)*0.01)
	line += 1
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			if in_dialogue:
				if next_line():
					$ColorRect/MarginContainer/VBoxContainer.visible = false
					$ColorRect/MarginContainer/OptionButton.visible = true
					in_dialogue = false

func _on_option_button_item_selected(index):
	if index == 1:
		PlayerKeymap.alter_mode = Mode.MOVING
	elif index == 2:
		PlayerKeymap.alter_mode = Mode.SCRAMBLED
	elif index == 3:
		PlayerKeymap.alter_mode = Mode.SCRAMBLED_AND_MOVING
	else: 
		PlayerKeymap.alter_mode = Mode.NONE
	self.visible = false
	$ColorRect/MarginContainer/OptionButton.visible = false
	finished = true
	SceneTransition.unlocked_door = true
