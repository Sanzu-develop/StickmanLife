class_name ObjectBar
extends MarginContainer


@export var view_world : ViewWorld
@export var details_bar : DetailsBar

@export var object_container : VBoxContainer

@export var object_ui : PackedScene


func _ready() -> void:
	_atualize()

func _atualize():
	if not object_container or not view_world: return
	
	var world = view_world.get_world()
	if not world: return
	
	var form = world.form
	
	var draw_list = form.get_draw_list()
	
	var value = draw_list.size()
	
	ChildManager.organize_childs(object_container,value,object_ui)
	
	var children = object_container.get_children()
	var id : int = 0
	for data_object_draw in draw_list:
		if id >= children.size(): return
		
		var new_name = data_object_draw.name
		if children[id] is ObjectUI: 
			children[id].id = id
			children[id].world = world
			children[id].set_new_name(new_name)
			if not children[id].selected.is_connected(details_bar._atualize):
				children[id].selected.connect(details_bar._atualize)
		
		id += 1
