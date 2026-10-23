@icon("res://Sprites/UISprites/Icons/ui/coding/icon-graph-bar-ui.png")
class_name DetailsBar
extends MarginContainer


signal property_atualize(drawer_type: int, drawer_id: int, property_name: String, new_value: Variant)
signal create_drawer(type: int)

@export var manager: InterfaceManager

@export_group("Parent")

@export_subgroup("Item")
@export var form_item_parent : VBoxContainer
@export var form_item_add : Button
@export var bone_item_parent : VBoxContainer
@export var bone_item_add : Button
@export var childs_item_prefab_count : int = 1

@export_subgroup("Property")
@export var form_object_parent : HBoxContainer
@export var bone_object_parent : HBoxContainer
@export var childs_property_prefab_count : int = 1


@export_group("Packed")
@export var packed_detail_item : PackedScene
@export var packed_object_item : PackedScene

var form_id : int = 0
var bone_id : int = 0


#===============
func atualize():
	atualize_object_nodes()
	atualize_property_nodes()
#===========


# Atualiza os botões de alternancia entre os ossos/formas
func atualize_object_nodes():
	var draw_object = manager.get_draw_data()

	_atualize_form_objects(draw_object.data_form)
	_atualize_bone_objects(draw_object.data_bone)
	
	if not form_item_add.pressed.is_connected(_on_add_item.bind(1)):
		form_item_add.pressed.connect(_on_add_item.bind(1))
	if not bone_item_add.pressed.is_connected(_on_add_item.bind(2)):
		bone_item_add.pressed.connect(_on_add_item.bind(2))
#-----

func _atualize_form_objects(form_list: Array[FormResource]):
	# Organiza a quantidade de filhos necessarios
	var form_size = form_list.size()
	ChildManager.organize_childs(form_object_parent,form_size + childs_item_prefab_count, packed_object_item)
	
	# Atualiza um por um e os coloca nos conformes
	var child_count = form_object_parent.get_child_count()
	for id in range(child_count):
		var i = form_object_parent.get_child(id + childs_item_prefab_count) as Button
		
		if not i: continue
		
		var text_button: String = str("%s - %s" % [id, form_list[id].name])
		i.text = text_button
		
		if not i.pressed.is_connected(set_form_id):
			i.pressed.connect(set_form_id.bind(id))

func _atualize_bone_objects(bone_list: Array[BoneResource]):
	# Organiza a quantidade de filhos necessarios
	var bone_size = bone_list.size()
	ChildManager.organize_childs(bone_object_parent,bone_size + childs_item_prefab_count, packed_object_item)
	
	# Atualiza um por um e os coloca nos conformes
	var child_count = bone_object_parent.get_child_count()
	for id in range(child_count):
		var i = bone_object_parent.get_child(id + childs_item_prefab_count) as Button
		
		if not i: continue
		
		var text_button: String = str("%s - %s" % [id, bone_list[id].name])
		i.text = text_button
		
		if not i.pressed.is_connected(set_bone_id):
			i.pressed.connect(set_bone_id.bind(id))
#---------------------

# Atualiza os botões de modificação de propriedade
func atualize_property_nodes():
	var draw_object = manager.get_draw_data()
	_atualize_form_propertys(draw_object.get_form(form_id))
	_atualize_bone_propertys(draw_object.get_bone(bone_id))
#-----

func _atualize_form_propertys(data_form: FormResource):
	var form_property_list : Array[Property] = InspetorEditorProperty.get_all_property(data_form)
	
	var propertys_count = form_property_list.size()
	
	ChildManager.organize_childs(form_item_parent,propertys_count + childs_property_prefab_count, packed_detail_item)
	
	var form_item_childs = form_item_parent.get_children()
	
	# Conecta o sinal de modificação a função que atualiza o mundo
	for form_property_child in form_item_childs:
		if not form_property_child is DetailItemUI: continue
		if not form_property_child.property_changed.is_connected(_on_property_atualize): form_property_child.property_changed.connect(_on_property_atualize)
	
	
	for id in range(propertys_count):
		var form_property = form_property_list[id]
		var form_type_id = 1
		form_item_childs[id + childs_property_prefab_count].initialize(form_type_id, form_id, form_property)

func _atualize_bone_propertys(data_bone: BoneResource):
	var bone_property_list : Array[Property] = InspetorEditorProperty.get_all_property(data_bone)
	
	var propertys_count = bone_property_list.size()
	
	ChildManager.organize_childs(bone_item_parent,propertys_count + childs_property_prefab_count, packed_detail_item)
	
	var bone_item_childs = bone_item_parent.get_children()
	
	# Conecta o sinal de modificação a função que atualiza o mundo
	for bone_property_child in bone_item_childs:
		if not bone_property_child is DetailItemUI: continue
		if not bone_property_child.property_changed.is_connected(_on_property_atualize): bone_property_child.property_changed.connect(_on_property_atualize)
	
	
	for id in range(propertys_count):
		var bone_property = bone_property_list[id]
		var bone_type_id = 2
		bone_item_childs[id + childs_property_prefab_count].initialize(bone_type_id, bone_id, bone_property)

#---------------------

func _on_property_atualize(drawer_type: int, drawer_id: int, property_name: String, new_value: Variant):
	property_atualize.emit(drawer_type, drawer_id, property_name, new_value)

func _on_add_item(type: int):
	if type == 1 or type == 2:
		create_drawer.emit(type)


func set_form_id(id: int):
	form_id = id
	atualize_property_nodes()

func set_bone_id(id: int):
	bone_id = id
	atualize_property_nodes()
