extends Panel


var resizing: bool = false



func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			resizing = event.pressed
	
	if event is InputEventMouseMotion:
		if resizing:
			self.custom_minimum_size.x = max( 448.0,min(self.custom_maximum_size.x ,self.custom_minimum_size.x - event.relative.x))
