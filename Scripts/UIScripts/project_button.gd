class_name ProjectButton
extends Button


signal star_click(is_star: bool)

@export var text_label: Label
@export var texture_rect: TextureRect
@export var star_button: CheckBox

var star: bool =false


func atualize_with_project(project: Project):
	pass

func rename(new_name: String) -> void:
	text_label.text = new_name


func _on_star_pressed() -> void:
	star = star_button.button_pressed
	star_click.emit(star)
