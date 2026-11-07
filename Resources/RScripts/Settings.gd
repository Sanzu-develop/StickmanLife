@icon("res://Sprites/UISprites/Settings.png")
class_name Settings
extends Resource


static var setting: Settings = null

@export_group("Project")
@export var project_autosave: bool = true

@export_group("Accessibility")
@export var language: String = "en"

var translates: PackedStringArray = ["en","pt"]

var save_path: String = "user://user/settings"


# ========================================================
# LIFETIME
# ========================================================


func _init() -> void:
	atualize_language()


# ========================================================
# ACCESSIBILITY
# ========================================================


func set_language(new_language: String) -> bool:
	if translates.has(new_language):
		language = new_language
		atualize_language()
		return true
	
	return false

func atualize_language():
	var all_translates = TranslationServer.get_loaded_locales()
	translates = all_translates
	
	TranslationServer.set_locale(language)


# ========================================================
# LOAD AND SAVE
# ========================================================


static func force_path(path: String) -> bool:
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)
		return false
	return true

func save():
	force_path(save_path)
	
	


# ========================================================
# STATIC
# ========================================================

static func set_setting(current_setting: Settings):
	setting = current_setting

static func get_setting() -> Settings:
	return setting
