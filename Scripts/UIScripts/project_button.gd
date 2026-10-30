class_name ProjectButton
extends Button


@export var text_label: Label
@export var texture_rect: TextureRect


func rename(new_name: String) -> void:
	text_label.text = new_name
