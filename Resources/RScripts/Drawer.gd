class_name Drawer
extends Resource

# IDS DE RECONHECIMENTO
# Not Are:  -1
# Object :   0
# Form   :   1
# Bone   :   2

static func get_id_type(draw_resource: Drawer) -> int:
	if not draw_resource: return -1
	if draw_resource is FormResource: return 1
	elif draw_resource is BoneResource: return 2
	return 0
