extends Label


onready var data = preload("res://gdnativetest1/bin/simple.gdns").new()


func _ready():
	pass # Replace with function body.


func _on_Button2_pressed():
	self.text = "Data = " + data.get_data()


