extends Panel


@export var tree: Tree
var resizing: bool = false



func _ready() -> void:
	var root = tree.create_item()
	
	for id in range(2):
		tree.set_column_custom_minimum_width(id + 1,32)
		tree.set_column_expand(id + 1,false)
	
	var item1 = tree.create_item(root)
	var item2 = tree.create_item(item1)
	item1.set_icon(2,preload("res://Sprites/UISprites/LockOn.png"))
	item1.set_icon(1,preload("res://Sprites/UISprites/Show.png"))
	item1.set_text(0,"Drawer")
	item1.set_icon(0,preload("res://Sprites/UISprites/Drawer.png"))
	
	item2.set_icon(2,preload("res://Sprites/UISprites/LockOff.png"))
	item2.set_icon(1,preload("res://Sprites/UISprites/Hide.png"))
	item2.set_text(0,"Skeleton")
	item2.set_icon(0,preload("res://Sprites/UISprites/Skeleton.png"))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			resizing = event.pressed
	
	if event is InputEventMouseMotion:
		if resizing:
			self.custom_minimum_size.x = max( 448.0,min(self.custom_maximum_size.x ,self.custom_minimum_size.x - event.relative.x))
