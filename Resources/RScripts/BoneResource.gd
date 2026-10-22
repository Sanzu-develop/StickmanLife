class_name BoneResource
extends Drawer

signal changed_bone
signal erase_bone

@export var name: String = "Bone"

@export var bone_parent: BoneResource:
	set(val):
		bone_parent = val
		changed_bone.emit()

@export var form_id: int = 0:
	set(val):
		form_id = val
		changed_bone.emit()

@export var local_position: Vector2 = Vector2.ZERO:
	set(val):
		local_position = val
		changed_bone.emit()

@export var offset: Vector2 = Vector2.ZERO:
	set(val):
		offset = val
		changed_bone.emit()

@export var deform: Vector2 = Vector2.ZERO:
	set(val):
		deform = val
		changed_bone.emit()

@export var angle: float = 0.0: # Rotação em grau
	set(val):
		angle = val
		changed_bone.emit()

@export var length: float = 50.0: # Tamanho fixo do osso
	set(val):
		length = val
		changed_bone.emit()


func get_start_position() -> Vector2:
	if bone_parent:
		return bone_parent.get_end_position() + offset
	return local_position + offset

func get_half_position() -> Vector2:
	var start = get_start_position()
	var end = get_end_position()
	
	# Ponto médio entre o início e o fim do osso
	var mid_point = (start + end) / 2.0
	return mid_point

func get_length_position() -> Vector2:
	var start = get_start_position()
	var end = get_end_position()
	
	var dir = (end - start).normalized()
	return dir * (length / 2.0)

func get_deform_position() -> Vector2:
	var start = get_start_position()
	var end = get_end_position()
	
	# Ponto médio entre o início e o fim do osso
	var mid_point = (start + end) / 2.0
	
	# Vetores de direção local (Para frente e Perpendicular/Para cima)
	var dir_x = (end - start).normalized()
	var dir_y = dir_x.orthogonal() # Perpendicular em 90 graus
	
	# Aplica o deslocamento X na direção do osso e Y na direção perpendicular
	var deform_position = mid_point + (dir_x * deform.x * (length / 2.0)) + (dir_y * deform.y)
	
	return deform_position

func get_end_position() -> Vector2:
	var start = get_start_position()
	var global_angle = get_global_angle()
	return start + Vector2.RIGHT.rotated(global_angle) * length

func get_global_angle(in_rad: bool = true) -> float:
	var a = angle
	if bone_parent:
		a += bone_parent.get_global_angle(false)
	if in_rad: a = deg_to_rad(a)
	return a

func look_at(position: Vector2):
	var new_angle = get_start_position().angle_to_point(position)
	
	var global_angle = get_global_angle()
	
	var diference_angle = global_angle - new_angle
	
	angle += diference_angle

func go_to_position(position : Vector2):
	local_position = position
	changed_bone.emit()

func erase():
	erase_bone.emit()
