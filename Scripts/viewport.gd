@icon("res://Sprites/UISprites/Icons/ui/files_data/icon-globe-ui.png")
class_name ViewWorld
extends SubViewportContainer

@export var viewport : SubViewport
@export var world : World_2D


func _gui_input(event: InputEvent) -> void:
	if viewport:
		viewport.push_input(event)

func get_world() -> World_2D:
	return world
