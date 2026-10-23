@icon("res://Sprites/UISprites/Icons/ui/files_data/icon-signal-emit-ui.png")
class_name InterfaceManager
extends Control

# Gerencia todos os objetos da interface...
# e faz a comunicação entre os mesmos.

@export_group("Center UI")
@export_subgroup("Inpector")
@export var objects_bar: ObjectBar
@export var details_bar: DetailsBar
@export_subgroup("Inpector")
@export var world: World_2D
@export var viewport_world: ViewWorld



#==================================================================
# LIFE CICLE
#==================================================================


func _ready() -> void:
	objects_bar.atualize()
	details_bar.atualize()


#==================================================================
# WORLD
#==================================================================


func get_world() -> World_2D:
	return world

func get_draw_list() -> Array[ObjectDraw]:
	if not world: return []
	
	var form = world.form
	
	var draw_list = form.get_draw_list()
	
	return draw_list

func get_draw_data(id: int = -1) -> ObjectDraw:
	var form = get_form_manager()
	if not form: return
	
	if id == -1: id = form.object_id
	
	var object_draw = form.get_draw_data(id)
	
	return object_draw

func get_draw_selected_id() -> int:
	var draw_selected = world.form.object_id
	return draw_selected

func get_form_manager() -> FormManager:
	if not world: return null
	var form = world.form
	return form

#==================================================================
# CALLS
#==================================================================


func selected_draw_object(id: int):
	world.form.set_object_id(id)
	details_bar.atualize()


func property_atualize(drawer_type: int, drawer_id: int, property_name: String, new_value: Variant) -> void:
	var object_draw = get_draw_data()
	if drawer_type == 1:
		object_draw.set_property_form(drawer_id, property_name, new_value)
	elif drawer_type == 2:
		object_draw.set_property_bone(drawer_id, property_name, new_value)


func create_drawer(type: int):
	var drawer = Drawer.create_drawer(type)
	if not drawer: return
	
	if type == 1 or type == 2:
		var draw_data = get_draw_data()
		
		draw_data.add_data(drawer)
		
		details_bar.atualize()
	elif type == 0:
		var form = get_form_manager()
		
		form.add_object(drawer)
