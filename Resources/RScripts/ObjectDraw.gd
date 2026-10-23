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

func set_property_form(form_id: int, property_name: String, new_value: Variant):
	var form = get_form(form_id)
	if not form: return
	form.set(property_name,new_value)
	_atualize()

func set_property_bone(bone_id: int, property_name: String, new_value: Variant):
	var bone = get_bone(bone_id)
	if not bone: return
	bone.set(property_name,new_value)
	_atualize()

func add_data(data: Drawer):
	if not data: return
	var type_data = Drawer.get_id_type(data)
	if type_data == 1:
		data_form.push_back(data)
	elif type_data == 2:
		data_bone.push_back(data)
	else: return
	
	_atualize()

func _atualize():
	object_changed.emit()
