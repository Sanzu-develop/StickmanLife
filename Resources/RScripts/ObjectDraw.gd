class_name ObjectDraw
extends Drawer

signal object_changed

@export var name : String = "Object Draw"

@export var data_form: Array[FormResource]
@export var data_bone: Array[BoneResource]


func initiate() -> void:
	for bone in data_bone:
		if not bone.changed_bone.is_connected(_atualize): 
			bone.changed_bone.connect(_atualize)
	for form in data_form:
		if not form.changed_data.is_connected(_atualize): 
			form.changed_data.connect(_atualize)

func get_form(id: int) -> FormResource:
	if id < 0 or id >= data_form.size(): return
	return data_form[id]

func get_bone(id: int) -> BoneResource:
	if id < 0 or id >= data_bone.size(): return
	return data_bone[id]

func _atualize():
	object_changed.emit()
