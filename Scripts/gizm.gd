class_name Gizm
extends Area2D


signal position_changed(new_position: Vector2, select_node: Node2D)

@export var selected_node : Node2D
@export var size : float = 200.0


# Faz a manipulação de interação
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if selected_node:
		if event is InputEventMouseMotion:
			if event.pressure:
				position_changed.emit(get_global_mouse_position(),selected_node)

# Inicia o método de desenho
func _draw() -> void:
	var distorce_size : float = 0.5
	
	var lines = PackedVector2Array([
		Vector2.ZERO, Vector2(0.0, -size * distorce_size),
		Vector2.ZERO,Vector2(size * distorce_size,0.0)])
	
	var colors = PackedColorArray([Color.GREEN, Color.RED])
	
	var distorce_width : float = 0.1
	draw_multiline_colors(lines,colors,size * distorce_width)
	pass

# Inicia os processos básicos
func node_pressed(active: bool, node: Node2D):
	if active:
		if node != selected_node:
			selected_node = node
			go_to(selected_node.global_position)
		else:
			selected_node = null
	
	var run = selected_node != null
	visible = run

# Vai para uma nova posição
func go_to(new_position: Vector2):
	global_position = new_position

#func _atualize_node():
	#if selected_node:
		#selected_node.global_position = global_position
		#if selected_node is BonePoint:
			#selected_node._atualize_bone()
