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
@export var colision : CollisionShape2D

var pressed : bool = false

#@export var bone_id : int = 0:
	#set(val):
		#bone_id = val
		#if bone_resource:
			#go_to_bone()

func _ready() -> void:
	_atualize()
	go_to_bone()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and owner is World_2D:
			owner.child_pressed(true,self)

func _draw() -> void:
	draw_circle(Vector2.ZERO,30.0,color)

func _atualize():
	queue_redraw()
	
	if get_child_count() == 0 or not get_children().has(CollisionShape2D) or not colision:
		var new_colision2D = CollisionShape2D.new()
		add_child(new_colision2D)
		colision = new_colision2D
		var form_gizm = CircleShape2D.new()
		colision.shape = form_gizm
	
	colision.shape.radius = size

# !
#func atualize_bone_resource_position():
	#if bone_resource: 
		#var mid_point = bone_resource.get_length_position()
		#bone_resource.go_to_position(position - mid_point)

func set_bone(new_bone: BoneResource):
	bone_resource = new_bone
	go_to_bone()

func go_to_bone():
	queue_redraw()
	if bone_resource:# and bone_id > 0 and bone_id < bone_resource.data_bone.size():
		position = bone_resource.get_half_position()

# ----

func go_to_position(new_position: Vector2):
	position = new_position
	atualize_bone_propertys()

func atualize_bone_propertys():
	if not bone_resource: return
	if not bone_property_name_x.is_empty():
		bone_resource.set(bone_property_name_x,bone_property_value_x)
	if not bone_property_name_y.is_empty():
		bone_resource.set(bone_property_name_y,bone_property_value_y)
