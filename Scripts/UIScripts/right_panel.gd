extends Panel


@export var tree: Tree
var resizing: bool = false



func _ready() -> void:
	var root = tree.create_item()
	
	var item1 = tree.create_item(root,0)
	item1.set_text(0,"abu")
	
	var item2 = tree.create_item(root,1)
	item2.set_text(0,"oi")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			resizing = event.pressed
	
	if event is InputEventMouseMotion:
		if resizing:
			self.custom_minimum_size.x = max( 448.0,min(self.custom_maximum_size.x ,self.custom_minimum_size.x - event.relative.x))
