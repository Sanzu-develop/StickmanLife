class_name BoneManager
extends Node2D


#var limit_bone_child : Array[Vector2i]



#func _ready() -> void:
	#organize_childs()
#
#func atualize_bones():
	#for bone in get_children():
		#if not bone is BonePoint: return
		#bone.go_to_bone()
#
#func organize_childs():
	#if not owner is World_2D: return
	#
	#var draw_object = owner.form.get_draw_data() as ObjectDraw
	#
	##limit_bone_child.clear()
	#
	#var bone_count : int = 0
	#var child_list = get_children()
	#
	#bone_count += draw_object.data_bone.size()
#
	## Define variáveis essenciais para não repetição
	#var diference = child_list.size() - bone_count
	#
	## Organiza a quantidade necessária de filhos
	#if diference < 0:
		#for i in range(-diference):
			#create_bone_point()
	#elif diference > 0:
		#for i in range(diference):
			#var node_to_remove = child_list.pop_back()
			#node_to_remove.queue_free()
			#remove_child(node_to_remove)
	#
	#
	## Organiza os pontos ósseos com seus respectivos ossos
	#child_list = get_children()
	#
	#var child_id : int = 0
	#for bone_resource in draw_object.data_bone:
		#if child_id >= child_list.size(): return
		#
		#if child_list[child_id].owner != owner: child_list[child_id].owner = owner
		#child_list[child_id].set_bone(bone_resource)
		#child_id += 1
#
#func create_bone_point() -> BonePoint:
	#var bone_point = BonePoint.new()
	#add_child(bone_point)
	#return bone_point
