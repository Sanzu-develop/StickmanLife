class_name Log


static var logs : String = "Logs \n"

static func register_log(value: Variant):
	var message = str(value)
	if message.is_empty(): return
	
	logs += message + "\n"

static func get_logs() -> String:
	return logs
