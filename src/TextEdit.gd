extends TextEdit
class_name GDREPL


const prompt_string = ">"

var eval_script = null



func _ready():
	self.connect("cursor_changed", self, "_on_cursor_changed")
	self.set_text(prompt_string)
	self.set_cursor_to_end()
	self.eval_script = GDScript.new()
	self.eval_script.source_code = ""
	self.eval_script.source_code += "extends GDREPL\n"
	self.eval_script.source_code += "var eval_funcstate = null\n"
	self.eval_script.source_code += "func _resume():\n"
	self.eval_script.source_code += "\tif self.eval_funcstate == null:\n"
	self.eval_script.source_code += "\t\tself._eval()\n"
	self.eval_script.source_code += "\telse:\n"
	self.eval_script.source_code += "\t\tself.eval_funcstate = self.eval_funcstate.resume()\n"
	self.eval_script.source_code += "func _eval():\n"
	self.eval_script.source_code += "\tyield()\n"
	var valid = self.eval_script.reload(false)
	if valid != OK:
		return
	#self.get_tree().add_child(self)


func eval_code(code):
	for line in code.split("\n"):
		self.eval_script.source_code += "\n\t" + line
	self.eval_script.source_code += "\n\tyield()"
	var valid = self.eval_script.reload(true)
	if valid != OK:
		return
	self.eval_script._resume()


func printa(x):
	print(x)


func toLabel(x):
	var label = self.get_tree().get_node("REPL").get_node("Label")
	print("IM HERE")
	var z = 0.0
	var y = 1.0/z
	label.set_text("DEF")
	

func set_cursor_to_end():
	self.cursor_set_line(self.get_line_count()-1)
	self.cursor_set_column(self.get_line(self.cursor_get_line()).length())


func is_cursor_on_last_line() -> bool:
	return not self.cursor_get_line() < self.get_line_count()-1


func is_cursor_in_readonly() -> bool:
	if not self.is_cursor_on_last_line():
		return true
	elif self.cursor_get_column() < prompt_string.length():
		return true
	else:
		return false


func get_current_code_line():
	var code = self.get_text()
	var n = code.rfind(">")
	return code.substr(n+1,code.length()-n-1)


func eval_current_input():
	self.eval_code(self.get_current_code_line())


func _on_cursor_changed():
	self.set_readonly(self.is_cursor_in_readonly())


func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		self.eval_current_input()
		self.text += "\n" + prompt_string
		self.set_cursor_to_end()
		self.get_tree().set_input_as_handled() # Don't let the base append a new line.
	elif Input.is_key_pressed(KEY_BACKSPACE):
		if self.cursor_get_column() <= prompt_string.length():
			self.get_tree().set_input_as_handled()

