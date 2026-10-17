class_name ChildManager


static func organize_childs(parent : Node, count_child : int, packed_new_child : PackedScene, disconnect_signals: Dictionary[String, String] = {}):
	
	var diference = parent.get_child_count() - count_child
	var child_list = parent.get_children()
	
	if diference < 0:
		for i in range(-diference):
			spawn_packed_child(parent,packed_new_child)
	elif diference > 0:
		for i in range(diference):
			var node_to_remove = child_list.pop_back()
			
			erase_child(parent,node_to_remove,disconnect_signals)

static func spawn_packed_child(parent: Node,new_child_packed: PackedScene) -> Node:
	if new_child_packed.can_instantiate():
		var instantiated_child = new_child_packed.instantiate()
		parent.add_child(instantiated_child)
		return instantiated_child
	return null

static func erase_child(parent: Node, node_to_remove: Node, disconnect_signals: Dictionary[String, String] = {}):
	for sig_name in disconnect_signals.keys():
		var func_name = disconnect_signals[sig_name]
		disconnect_signal(parent,node_to_remove,sig_name,func_name)
	parent.remove_child(node_to_remove)
	node_to_remove.queue_free()

static func disconnect_signal(parent_signal: Node, target_connected: Node, signal_name: String, function_name: String):
	if parent_signal.is_connected(signal_name,Callable(target_connected, function_name)):
		parent_signal.disconnect(signal_name,Callable(target_connected, function_name))
