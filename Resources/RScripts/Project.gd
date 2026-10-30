class_name Project
extends Resource


@export var name: String = "Project"
@export var object_draw_list: Array[ObjectDraw]


func set_objects_in_form(form_manager: FormManager):
	if not form_manager: return
	
	object_draw_list = form_manager.get_draw_list()

func get_object_list() -> Array[ObjectDraw]:
	return object_draw_list
