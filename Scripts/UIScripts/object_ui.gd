class_name ObjectUI
extends Panel



signal selected

@export var image : TextureRect
@export var text : LineEdit

@export var world : World_2D
var id : int = 0



func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if world.form: world.form.set_object_id(id)
			selected.emit()

#func 

func set_new_name(new_name: String):
	if text: text.text = new_name

func update_style(active: bool):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.4, 0.4, 0.4, 0.6) if active else Color(0.102, 0.102, 0.102, 0.6)
	add_theme_stylebox_override("panel",style)
