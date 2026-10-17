class_name DetailItemUI
extends PanelContainer

signal property_changed(property_name: String, new_value: Variant)

@export var property_parent: HBoxContainer
@export var property_text: Label

var item_resource: Drawer
var property_name: String = ""
var property_value: Variant
var property_type: Variant.Type
var property_control: Control


func initialize(new_resource: Drawer, new_name: String, new_value: Variant) -> void:
	item_resource = new_resource
	property_name = new_name
	property_value = new_value
	_update_ui()

func _update_ui() -> void:
	if property_text:
		property_text.text = property_name

	var new_type: Variant.Type = typeof(property_value) as Variant.Type

	# Se o controle não existe ou o tipo do dado mudou, recria o nó de UI
	if not property_control or property_type != new_type:
		_recreate_control(new_type)
	else:
		# Se o nó já é do tipo correto, apenas atualiza o valor
		DynamicData.set_control_value(property_control, property_value)

func _recreate_control(new_type: Variant.Type) -> void:
	# Remove o controle antigo se ele existir
	if property_control and is_instance_valid(property_control):
		ChildManager.erase_child(property_parent, property_control)

	# Atualiza o tipo guardado e cria o novo nó
	property_type = new_type
	property_control = DynamicUIFactory.create_control(property_value)

	if property_control:
		property_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		property_parent.add_child(property_control)
		
		DynamicUIFactory.connect_value_changed(property_control,_on_value_modified)

func _on_value_modified(new_value: Variant) -> void:
	property_value = new_value
	
	if item_resource and not property_name.is_empty():
		item_resource.set(property_name,property_value)
	
	property_changed.emit(property_name,property_value)
