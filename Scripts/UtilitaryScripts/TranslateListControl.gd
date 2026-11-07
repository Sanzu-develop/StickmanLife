class_name TranslateList


static func translate_control_list(control: Control,keys: Array[String]):
	if "clear" in control:
		control.clear()
	
	for key in keys:
		var translated_text = TranslationServer.translate(key)
		
		if "add_item" in control:
			control.add_item(translated_text)
