@icon("res://Sprites/UISprites/Icons/2d/files_data/icon-globe-2d.png")
class_name World_2D
extends Node2D


@export var form : FormManager
@export var gizm : Gizm
@export var bones : BoneManager


func child_pressed(active: bool, node: Node2D) -> void:
	if gizm:
		gizm.node_pressed(active,node)

func atualize_bone() -> void:
	return
	if bones: bones.organize_childs()

func atualize_bones_property() -> void:
	return
	bones.atualize_bones()

func _on_form_object_changed() -> void:
	pass # Replace with function body.

func _on_gizm_position_changed(new_position: Vector2, select_node: Node2D) -> void:
	if select_node is BonePoint:
		select_node.go_to_position(new_position)
