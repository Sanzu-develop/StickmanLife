@icon("res://Sprites/UISprites/Icons/ui/coding/icon-graph-bar-ui.png")
class_name ObjectBar
extends MarginContainer


signal object_selected(id: int)

@export var manager: InterfaceManager

@export var object_container : VBoxContainer

@export var object_ui : PackedScene


func atualize():
	if not object_container: return
	
	var draw_list = manager.get_draw_list()
	
	var value = draw_list.size()
	
	ChildManager.organize_childs(object_container,value,object_ui)
	
	var children = object_container.get_children()
	
	for id in range(value):
		var data_object_draw = draw_list[id]
		
		var new_name = data_object_draw.name
		
		if not children[id] is ObjectUI: return
		
		children[id].id = id
		children[id].set_new_name(new_name)
		
		if not children[id].selected.is_connected(on_object_selected.bind(id)):
			children[id].selected.connect(on_object_selected.bind(id))
	
	var id : int = manager.get_draw_selected_id()
	focus_object(id)

func on_object_selected(id: int):
	object_selected.emit(id)
	
	focus_object(id)

func focus_object(id: int):
	for object_button in object_container.get_children():
		if not object_button is ObjectUI: continue
		object_button.select(false)
	
	var selected_object_button = object_container.get_child(id)
	if selected_object_button and selected_object_button is ObjectUI:
		selected_object_button.select(true)
