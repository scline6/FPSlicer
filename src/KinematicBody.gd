extends KinematicBody

var mouse_posL      = Vector2(0.0, 0.0)
var mouse_deltaL    = Vector2(0.0, 0.0)
var xysensitivity   = 1.0
var xydecel         = 0.5
var xyspeed         = Vector2(0.0, 0.0)
var mouse_posR      = Vector2(0.0, 0.0)
var mouse_deltaR    = Vector2(0.0, 0.0)
var rsensitivity    = 0.1
var rdecel          = 0.5
var raxis           = Vector3(0.0, 0.0, 1.0)
var rspeed          = 0.0
var mouse_scroll    = 0.0
var zsensitivity    = 1.0
var zdecel          = 0.2
var zspeed          = 0.0


func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				self.mouse_posL = event.position
			else:
				self.mouse_deltaL = event.position - self.mouse_posL
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				self.mouse_posR = event.position
			else:
				self.mouse_deltaR = event.position - self.mouse_posR
		elif event.button_index == BUTTON_WHEEL_DOWN:
			self.mouse_scroll = -1.0
		elif event.button_index == BUTTON_WHEEL_UP:
			self.mouse_scroll = 1.0


func _process(delta):
	return;
	if self.mouse_deltaL != Vector2(0.0, 0.0):
		self.xyspeed = self.xysensitivity * self.mouse_deltaL
	else:
		self.xyspeed *= (1.0 - self.xydecel)
		if self.xyspeed.length() < 0.01:
			self.xyspeed = Vector2(0.0, 0.0)
	if self.mouse_deltaR != Vector2(0.0, 0.0):
		var n = Vector3(self.mouse_deltaR.y, -self.mouse_deltaR.x, 0.0).normalized()
		var raccel = self.rsensitivity * self.mouse_deltaR.length()
		self.raxis = (self.raxis * self.rspeed + n * raccel).normalized()
		if self.raxis.length() < 1e-12:
			self.raxis = Vector3(0.0, 0.0, 1.0)
		self.rspeed += raccel * delta
	else:
		self.rspeed *= (1.0 - rdecel)
		if self.rspeed < 0.01:
			self.rspeed = 0.0
	if self.mouse_scroll != 0.0:
		self.zspeed = self.zsensitivity * self.mouse_scroll
	else:
		self.zspeed *= (1.0 - zdecel)
		if self.zspeed < 0.01:
			self.zspeed = 0.0
	var disp = Vector3(self.xyspeed.x * delta, self.xyspeed.y * delta, self.zspeed)
	self.translate(disp)
	var offset = self.get_translation()
	self.translate(-offset)
	self.rotate(self.raxis, self.rspeed) 
	self.translate(offset)   #need to consider center of view
	self.mouse_deltaL = Vector2(0.0, 0.0)
	self.mouse_deltaR = Vector2(0.0, 0.0)
	self.mouse_scroll = 0.0


func _physics_process(delta):
	if self.mouse_deltaL != Vector2(0.0, 0.0):
		self.xyspeed = self.xysensitivity * self.mouse_deltaL
	else:
		self.xyspeed *= (1.0 - self.xydecel)
		if self.xyspeed.length() < 0.01:
			self.xyspeed = Vector2(0.0, 0.0)
	if self.mouse_deltaR != Vector2(0.0, 0.0):
		var n = Vector3(self.mouse_deltaR.y, -self.mouse_deltaR.x, 0.0).normalized()
		var raccel = self.rsensitivity * self.mouse_deltaR.length()
		self.raxis = (self.raxis * self.rspeed + n * raccel).normalized()
		if self.raxis.length() < 1e-12:
			self.raxis = Vector3(0.0, 0.0, 1.0)
		self.rspeed += raccel * delta
	else:
		self.rspeed *= (1.0 - rdecel)
		if self.rspeed < 0.01:
			self.rspeed = 0.0
	if self.mouse_scroll != 0.0:
		self.zspeed = self.zsensitivity * self.mouse_scroll
	else:
		self.zspeed *= (1.0 - zdecel)
		if self.zspeed < 0.01:
			self.zspeed = 0.0
	var disp = Vector3(self.xyspeed.x * delta, self.xyspeed.y * delta, self.zspeed)
	
	#print("_PHYSICS_PROCESS")
	var space_state = get_world().get_direct_space_state()
	var obstacle = space_state.intersect_ray(self.get_translation(), self.get_translation()+disp)
	#var obstacle = space_state.intersect_ray(Vector3(-200.0,-200.0,-200.0), Vector3(200.0,200.0,200.0))
	if not obstacle.empty():
		#print("COLLISION")
		pass
	else:
	    self.translate(disp)
	var offset = self.get_translation()
	self.translate(-offset)
	self.rotate(self.raxis, self.rspeed) 
	self.translate(offset)   #need to consider center of view
	self.mouse_deltaL = Vector2(0.0, 0.0)
	self.mouse_deltaR = Vector2(0.0, 0.0)
	self.mouse_scroll = 0.0
	


