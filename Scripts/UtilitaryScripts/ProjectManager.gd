class_name ProjectManager
extends Resource


static var local_save: String = "user://user/projects"

static var project: Project = null
@export var project_list: Array[Project] = []

static var extension_text: String = ".proj"



static func has_project() -> bool:
	return project != null

static func select_project(id: int, projects: Array[Project]) -> void:
	if id >= 0 and id < projects.size():
		project = projects[id]

static func set_project(new_project: Project) -> void:
	if new_project:
		project = new_project

static func get_project() -> Project:
	return project


static func recursive_path(path: String) -> bool:
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)
		return false
	return true

static func save_projects(save_project_list: Array[Project], path: String = local_save) -> void:
	if save_project_list.is_empty(): return
	
	recursive_path(path)
	
	for current_project in save_project_list:
		var path_save = path.path_join(str(current_project.name + extension_text))
		
		var error = ResourceSaver.save(current_project, path_save)
		
		if error != OK: Log.register_log("Houve um erro ao salvar projeto (error : %s)" % error, true)

static func load_projects(path: String = local_save) -> Array[Project]:
	var loaded_project_list: Array[Project]
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Ignora pastas de sistema (. e ..)
			if not dir.current_is_dir() and file_name != "." and file_name != "..":
				if file_name.ends_with(extension_text):
					var full_path = path.path_join(file_name)
					var current_project = ResourceLoader.load(full_path)
					if current_project is Project:
						loaded_project_list.push_back(current_project)
			
			file_name = dir.get_next()
			
		dir.list_dir_end()
	
	return loaded_project_list
	#if ResourceLoader.exists(local_save):
		#var resource_saved = ResourceLoader.load(local_save)
		#if resource_saved is ProjectManager:
			#return resource_saved
	#
	#Log.register_log("Não encontrado gerenciador de projetos, Criando uma nova...", true)
	#return ProjectManager.new()


func get_project_list() -> Array[Project]:
	return project_list

func create_project(project_name: String) -> bool:
	var new_project = Project.new()
	
	new_project.name = project_name
	
	project_list.push_back(new_project)
	save_projects(project_list)
	return true
