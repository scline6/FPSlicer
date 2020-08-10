extends PopupMenu


func _on_ModelList_item_rmb_selected(index, at_position):
	var pos = self.get_parent().get_global_position() + at_position
	self.popup(Rect2(pos.x, pos.y, 200, 200))
	self.get_parent().selected_item_index = index


func _ready():
	self.add_item("Close Model", 0)
	self.add_item("Translate"  , 1)
	self.add_item("Rotate"     , 2)
	self.add_item("Scale"      , 3)
