extends FileDialog



func _ready():
	self.set_mode(FileDialog.MODE_OPEN_FILES)



func _on_OpenButton_pressed():
	self.popup_centered(Vector2(240, 360))

