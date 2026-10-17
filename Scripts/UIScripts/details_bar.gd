class_name DetailsBar
extends MarginContainer


@export var view_world : ViewWorld
@export var objects_bar : ObjectBar

@export var form_item_parent : VBoxContainer
@export var bone_item_parent : VBoxContainer
@export var form_object_parent : HBoxContainer
@export var bone_object_parent : HBoxContainer

@export var packed_detail_item : PackedScene
@export var packed_object_item : PackedScene

@export var form_id : int = 0
@export var bone_id : int = 0

@export var childs_prefab_count : int = 2


func _ready() -> void:
	_atualize()

func _atualize():
	_atualize_object_nodes()
	_atualize_property_nodes()

func _atualize_object_nodes():
	var world = view_world.get_world() as World_2D
	var form_manager = world.form as FormManager
	
	var draw_object = form_manager.get_draw_data() as ObjectDraw
	
	var form_list = draw_object.data_form
	var bone_list = draw_object.data_bone
	
	var form_size = draw_object.data_form.size()
	var bone_size = draw_object.data_bone.size()
	
	ChildManager.organize_childs(form_object_parent,form_size, packed_object_item)
	ChildManager.organize_childs(bone_object_parent,bone_size, packed_object_item)
	
	for id in range(form_object_parent.get_child_count()):
		var i = form_object_parent.get_child(id) as Button
		if not i: continue
		i.text = str("%s - %s" % [id, form_list[id].name])
		if not i.pressed.is_connected(set_form_id):
			i.pressed.connect(set_form_id.bind(id))
	
	for id in range(bone_object_parent.get_child_count()):
		var i = bone_object_parent.get_child(id) as Button
		if not i: continue
		i.text = str("%s - %s" % [id, bone_list[id].name])
		if not i.pressed.is_connected(set_bone_id):
			i.pressed.connect(set_bone_id.bind(id))

func _atualize_property_nodes():
	var world = view_world.get_world() as World_2D
	var form_manager = world.form as FormManager
	
	var draw_object = form_manager.get_draw_data() as ObjectDraw
	
	var data_form = draw_object.data_form[form_id]
	var data_bone = draw_object.data_bone[bone_id]
	
	var form_variable_dictionary = InspetorEditorProperty.get_all_property(data_form)
	var bone_variable_dictionary = InspetorEditorProperty.get_all_property(data_bone)
	
	var form_size = form_variable_dictionary.size()
	var bone_size = bone_variable_dictionary.size()
	
	ChildManager.organize_childs(form_item_parent,form_size + childs_prefab_count, packed_detail_item)
	ChildManager.organize_childs(bone_item_parent,bone_size + childs_prefab_count, packed_detail_item)
	
	var form_item_childs = form_item_parent.get_children()
	var bone_item_childs = bone_item_parent.get_children()
	
	# Conecta o sinal de modificação a função que atualiza o mundo
	for form_property_child in form_item_childs:
		if not form_property_child is DetailItemUI: continue
		if not form_property_child.property_changed.is_connected(_on_property_atualize): form_property_child.property_changed.connect(_on_property_atualize)
	for bone_property_child in bone_item_childs:
		if not bone_property_child is DetailItemUI: continue
		if not bone_property_child.property_changed.is_connected(_on_property_atualize): bone_property_child.property_changed.connect(_on_property_atualize)
	
	var key_forms = form_variable_dictionary.keys()
	var key_bones = bone_variable_dictionary.keys()
	
	for id in range(form_variable_dictionary.size()):
		var key = key_forms[id]
		var value : Variant = form_variable_dictionary[key]
		form_item_childs[id + childs_prefab_count].initialize(data_form,key,value)
	for id in range(bone_variable_dictionary.size()):
		var key = key_bones[id]
		var value = bone_variable_dictionary[key]
		bone_item_childs[id + childs_prefab_count].initialize(data_bone,key,value)

func _on_property_atualize(property_name: String, new_value: Variant):
	_atualize_world()

func _atualize_world() -> void:
	var world = view_world.get_world() as World_2D
	if not world: return
	
	world.atualize_bones_property()

func set_form_id(id: int):
	form_id = id
	_atualize_property_nodes()

func set_bone_id(id: int):
	bone_id = id
	_atualize_property_nodes()
