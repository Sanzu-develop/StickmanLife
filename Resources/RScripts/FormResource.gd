class_name FormResource
extends Drawer

signal changed_data

enum TypeForm { LINE, CIRCLE, CURVE }

@export var name: String = "Form"

@export var type: TypeForm = TypeForm.LINE:
	set(val):
		type = val
		changed_data.emit()

@export var radius: float = 50.0:
	set(val):
		radius = val
		changed_data.emit()

@export var resolution: int = 32:
	set(val):
		resolution = val
		changed_data.emit()

@export var width : float = 4.0:
	set(val):
		width = val
		changed_data.emit()

@export var color : Color = Color.BLACK:
	set(val):
		color = val
		changed_data.emit()
