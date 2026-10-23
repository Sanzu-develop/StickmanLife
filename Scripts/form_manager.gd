@icon("res://Sprites/UISprites/Icons/2d/geometry/icon-geo-butterfly-2d.png")
class_name FormManager
extends Node2D


signal object_changed

@export var objects : Array[ObjectDraw]
@export var object_id : int = 0

func _ready() -> void:
	_atualize_signal()

# Funções de desenho
func _draw() -> void:
	for data_draw in objects:
		var data_bone = data_draw.data_bone
		var data_form = data_draw.data_form
		for bone in data_bone:
			var form_id = bone.get("form_id")
			if form_id == null: continue
			
			if not bone or form_id < 0 or form_id >= data_form.size():
				continue
			
			var form = data_form[form_id]
			if not form: continue
			
			var trans = Transform2D(bone.get_global_angle(), bone.get_start_position())
			draw_set_transform_matrix(trans)
			
			var local_start = Vector2.ZERO
			var local_end = Vector2.RIGHT * bone.length
			
			var half_bone = bone.length / 2.0
			var half_bone_vector = Vector2(half_bone, 0.0)
			
			var local_deform = half_bone_vector + Vector2(bone.deform.x * half_bone, bone.deform.y)
			
			match form.type:
				FormResource.TypeForm.CIRCLE:
					draw_circle(local_start,form.radius,form.color)
				FormResource.TypeForm.LINE:
					draw_line(local_start,local_end,form.color,form.width)
				FormResource.TypeForm.CURVE:
					draw_bezier_curve(local_start,local_end,local_deform,form)
			
			draw_set_transform_matrix(Transform2D.IDENTITY)

func draw_bezier_curve(p_a: Vector2, p_b: Vector2, p_c: Vector2, data: FormResource) -> void:
	var points = PackedVector2Array()
	for i in range(data.resolution + 1):
		var t = float(i) / float(data.resolution)
		var u = 1.0 - t
		var point = (u * u * p_a) + (2.0 * u * t * p_c) + (t * t * p_b)
		points.append(point)
	draw_polyline(points, data.color, data.width)

func get_draw_data(id: int = object_id) -> ObjectDraw:
	if id < 0 or id >= objects.size(): return
	return objects[id]

func get_draw_list() -> Array[ObjectDraw]:
	return objects

func _atualize_signal():
	for object_draw in objects:
		object_draw.initiate()
		if not object_draw.object_changed.is_connected(_atualize_objects): object_draw.object_changed.connect(_atualize_objects)

func _atualize_objects():
	queue_redraw()
	object_changed.emit()

func set_object_id(new_id: int):
	if new_id >= 0 and new_id < objects.size():
		object_id = new_id
		if owner is World_2D:
			owner.atualize_bone()

func add_object(object: ObjectDraw):
	objects.push_back(object)
	queue_redraw()
