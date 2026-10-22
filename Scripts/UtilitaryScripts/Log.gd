class_name Log


static var logs : String = "Logs \n"

static func register_log(value: Variant, output_message: bool = false):
	var message = str(value)
	if message.is_empty(): return
	
	logs += message + "\n"
	
	if output_message: print(message)

static func get_logs() -> String:
	return logs
