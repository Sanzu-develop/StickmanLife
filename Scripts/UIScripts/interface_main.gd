class_name InterfaceMain
extends Control


@export_group("Project")
@export var projects_parent: GridContainer
@export var project_button_packed: PackedScene

@export var projects_windows_button: Button
var projects_button_text: String = "Meus Projetos (%s)"

@export var packed_editor: PackedScene

var project_manager: ProjectManager


func _ready() -> void:
	# Project config
	project_manager = ProjectManager.new()
	project_manager.project_list = ProjectManager.load_projects()
	
	# Atualize
	atualize_project_list()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			open_editor()

#========================================

func atualize_project_list():
	_atualize_project_button()

func _atualize_project_button():
	if not project_manager: return
	var projects = project_manager.get_project_list()
	
	var count_buttons = projects.size()
	
	projects_windows_button.text = projects_button_text % count_buttons
	
	ChildManager.organize_childs(projects_parent, count_buttons, project_button_packed)
	
	var buttons = projects_parent.get_children()
	
	# Add in future update of project in hub
	#if buttons.size() > 0:
		#_on_selected_project(0)
	
	for project_id in range(buttons.size()):
		var project_button = buttons[project_id] as ProjectButton
		var project = projects[project_id] as Project
		
		if project_button and project:
			project_button.rename(project.name)
			
			if not project_button.pressed.is_connected(_on_selected_project.bind(project_id)):
				project_button.pressed.connect(_on_selected_project.bind(project_id))

#========================================

func open_editor():
	if not ProjectManager.has_project(): return
	
	var editor = packed_editor.instantiate()
	if editor is InterfaceManager:
		editor.project_manager = project_manager
		get_tree().change_scene_to_node(editor)

func create_project():
	if project_manager.create_project("BaseProject"):
		atualize_project_list()

func show_projects(star: bool = false):
	if star:
		for i in projects_parent.get_children():
			if i is ProjectButton:
				if i.star: i.visible = true
				else: i.visible = false
	
	else: 
		for i in projects_parent.get_children():
			if i is ProjectButton:
				i.visible = true

#========================================

func _on_selected_project(id: int):
	var projects = project_manager.get_project_list()
	ProjectManager.select_project(id,projects)
	open_editor()

func _on_create_pressed() -> void:
	create_project()


func _on_projects_pressed() -> void:
	show_projects(false)
