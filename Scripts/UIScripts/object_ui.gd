@icon("res://Sprites/UISprites/Icons/ui/components/icon-comp-pencil-ui.png")
class_name ObjectUI
extends Panel



signal selected

@export var image : TextureRect
@export var text : LineEdit

var id : int = 0



func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			selected.emit()

func set_new_name(new_name: String):
	if text: text.text = new_name

func select(active: bool):
	if active: self_modulate = Color(2.0, 2.0, 2.0, 1.0)
	else: self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func update_style(active: bool):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.4, 0.4, 0.4, 0.6) if active else Color(0.102, 0.102, 0.102, 0.6)
	add_theme_stylebox_override("panel",style)
