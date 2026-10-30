class_name BonePoint
extends Area2D


@export_group("Resource")
@export var bone_resource : BoneResource
@export var bone_property_name_x : String = "local_position"
@export var bone_property_value_x : Variant = 0.0
@export var bone_property_type_x : int = TYPE_VECTOR2
@export var bone_property_name_y : String = "local_position"
@export var bone_property_value_y : Variant = 0.0
@export var bone_property_type_y : int = TYPE_VECTOR2

@export_group("Skin")
@export var size : float = 30.0
@export var color : Color = Color(0.867, 0.8, 0.93, 0.502)#Color(0.486, 0.0, 0.929, 0.502)

@export_group("Collision")
@export var collision : CollisionShape2D

var pressed : bool = false


#========================================================================
# CICLE
#========================================================================


func _ready() -> void:
	_atualize_collision()
	go_to_bone()


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and owner is World_2D:
			owner.child_pressed(true,self)


#========================================================================
# DRAW
#========================================================================


func _draw() -> void:
	draw_circle(Vector2.ZERO,30.0,color)


#========================================================================
# COLLISION
#========================================================================


# Atualiza a colisao
func _atualize_collision():
	if get_child_count() == 0 or not get_children().has(CollisionShape2D) or not collision:
		var new_collision2D = CollisionShape2D.new()
		collision = new_collision2D
		
		add_child(new_collision2D)
		
		var form_gizm = CircleShape2D.new()
		collision.shape = form_gizm
	
	collision.shape.radius = size


#========================================================================
# BONE
#========================================================================


# Adiciona as configurações iniciais necessárias para execução
func set_bone(new_bone: BoneResource):
	if not new_bone: return
	
	# Disconecta o sinal antigo caso haja
	if bone_resource and bone_resource.changed_bone.is_connected(go_to_bone):
		bone_resource.changed_bone.disconnect(go_to_bone)
	
	bone_resource = new_bone
	
	# Conecta um novo sinal para o novo osso
	if not bone_resource.changed_bone.is_connected(go_to_bone):
		bone_resource.changed_bone.connect(go_to_bone)
	
	go_to_bone()


func go_to_bone():
	queue_redraw()
	
	if bone_resource:
		position = bone_resource.get_half_position()
		_atualize_bone_propertys()


func _atualize_bone_propertys():
	if not bone_resource: return
	if not bone_property_name_x.is_empty():
		var bone_value_x = _convert_position_to_value(position.x, bone_property_type_x)
		bone_resource.set(bone_property_name_x,bone_value_x)
	
	if not bone_property_name_y.is_empty():
		var bone_value_y = _convert_position_to_value(position.y, bone_property_type_y)
		bone_resource.set(bone_property_name_y,bone_value_y)

func _convert_position_to_value(coord: float, prop_type: int) -> Variant:
	match prop_type:
		TYPE_FLOAT:
			return coord # Aqui você pode adicionar um multiplicador/escala se necessário, ex: coord * 0.1
		TYPE_INT:
			return int(coord)
		TYPE_VECTOR2:
			return position # Caso queira passar o Vector2 completo
		_:
			return coord
