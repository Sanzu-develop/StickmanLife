@icon("res://Sprites/UISprites/Icons/ui/components/icon-comp-wrench-ui.png")
class_name DetailItemUI
extends PanelContainer

signal property_changed(drawer_type: int, drawer_id: int, property_name: String, new_value: Variant)

@export var property_parent: HBoxContainer
@export var property_text: Label

var drawer_type: int
var property: Property
var property_control: Control

var id: int = 0


func initialize(type: int, new_id: int, new_property: Property) -> void:
	drawer_type = type
	id = new_id
	property = new_property
	_update_ui()

func _update_ui() -> void:
	if property_text:
		property_text.text = property.name

	var value : Variant = DynamicData.get_control_value(property_control)
	var type: Variant.Type = typeof(value) as Variant.Type

	# Se o controle não existe ou o tipo do dado mudou, recria o nó de UI
	if not property_control or property.type != type:
		_recreate_control(type)
	else:
		# Se o nó já é do tipo correto, apenas atualiza o valor
		DynamicData.set_control_value(property_control, property.value)

func _recreate_control(type: Variant.Type) -> void:
	# Remove o controle antigo se ele existir
	if property_control and is_instance_valid(property_control):
		ChildManager.erase_child(property_parent, property_control)

	# Atualiza o tipo guardado e cria o novo nó
	property.type = type
	property_control = DynamicUIFactory.create_control(property.value,property.hint,property.hint_string)

	if property_control:
		property_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		property_parent.add_child(property_control)
		
		DynamicUIFactory.connect_value_changed(property_control,_on_value_modified)

func _on_value_modified(new_value: Variant) -> void:
	property.value = new_value
	
	property_changed.emit(drawer_type, id, property.name, property.value)
