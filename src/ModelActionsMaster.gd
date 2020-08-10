extends Control

var OpenButton        = null
var CloseButton       = null
var ShowButton        = null
var HideButton        = null
var TranslateButton   = null
var RotateButton      = null
var ScaleButton       = null
var DropToPlateButton = null


func _ready():
	self.OpenButton        = self.find_node("OpenButton", true, false)
	self.CloseButton       = self.find_node("CloseButton", true, false)
	self.ShowButton        = self.find_node("ShowButton", true, false)
	self.HideButton        = self.find_node("HideButton", true, false)
	self.TranslateButton   = self.find_node("TranslateButton", true, false)
	self.RotateButton      = self.find_node("RotateButton", true, false)
	self.ScaleButton       = self.find_node("ScaleButton", true, false)
	self.DropToPlateButton = self.find_node("DropToPlateButton", true, false)
	self.set_all_except_open_to_disabled(true)


func set_all_except_open_to_disabled(off):
	print(off)
	self.CloseButton.set_disabled(off)
	self.ShowButton.set_disabled(off)
	self.HideButton.set_disabled(off)
	self.TranslateButton.set_disabled(off)
	self.RotateButton.set_disabled(off)
	self.ScaleButton.set_disabled(off)
	self.DropToPlateButton.set_disabled(off)




func _on_ModelList_nothing_selected():
	self.set_all_except_open_to_disabled(true)


func _on_ModelList_multi_selected(index, selected):
	self.set_all_except_open_to_disabled(false)


