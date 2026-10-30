class_name ProjectManager
extends Resource


static var local_save: String = "user://projects.tres"

static var project: Project = null
@export var project_list: Array[Project] = []



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


static func save_project_manager(project_manager: ProjectManager) -> void:
	if not project_manager: return
	
	var error = ResourceSaver.save(project_manager, local_save)
	if error != OK:
		Log.register_log("Houve um erro ao salvar projeto (error : %s)" % error, true)

static func load_project_manager() -> ProjectManager:
	if ResourceLoader.exists(local_save):
		var resource_saved = ResourceLoader.load(local_save)
		if resource_saved is ProjectManager:
			return resource_saved
	
	Log.register_log("Não encontrado gerenciador de projetos, Criando uma nova...", true)
	return ProjectManager.new()


func get_project_list() -> Array[Project]:
	return project_list

func create_project() -> bool:
	var new_project = Project.new()
	
	project_list.push_back(new_project)
	save_project_manager(self)
	return true
