class_name Project
extends Resource


@export var name: String = "Project"
@export var last_modify: Dictionary[String,int]
@export var object_draw_list: Array[ObjectDraw]


func _init() -> void:
	save_new_modify_time()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		save_new_modify_time()
		
		# AutoSave
		var settings = Settings.get_setting()
		if settings.project_autosave:
			ProjectManager.save_projects([self])

func save_new_modify_time():
	last_modify = Time.get_datetime_dict_from_system()

func set_objects_in_form(form_manager: FormManager):
	if not form_manager: return
	
	object_draw_list = form_manager.get_draw_list()
	save_new_modify_time()

func get_object_list() -> Array[ObjectDraw]:
	return object_draw_list
