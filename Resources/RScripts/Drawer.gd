class_name Drawer
extends Resource

# IDS DE RECONHECIMENTO
# Not Are:  -1
# Object :   0
# Form   :   1
# Bone   :   2

static func get_id_type(draw_resource: Drawer) -> int:
	if not draw_resource: return -1
	if draw_resource is ObjectDraw: return 0
	elif draw_resource is FormResource: return 1
	elif draw_resource is BoneResource: return 2
	return 0

static func create_drawer(id: int) -> Drawer:
	match id:
		0:
			var obj = ObjectDraw.new()
			return obj
		1:
			var form = FormResource.new()
			return form
		2: 
			var bone = BoneResource.new()
			return bone
	return null
