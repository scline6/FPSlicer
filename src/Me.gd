extends KinematicBody


const WALK_SPEED        = 50.0
const SPIN_SPEED        = 2.0
const ZOOM_SPEED        = 1.0
const ACCEL             = 5.0
const DEACCEL           = 5.0
const MAX_SLOPE_ANGLE   = 45.0
var   MOUSE_SENSITIVITY = 0.05


var dir  = Vector3()
var rot  = Vector2()
var zoom = 0.0
var vel  = Vector3()
var speed_mult = 1.0
var change_tablet_visibility = false


var camera          = null
var rotation_helper = null
var tablet          = null



func _ready():
	self.camera = $Rotation_Helper/Camera
	self.rotation_helper = $Rotation_Helper
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for i in range(0, self.get_child_count()):
		if self.get_child(i).get_filename().find("Tablet") >= 0:
			self.tablet = self.get_child(i)
			break


func _physics_process(delta):
    process_input(delta)
    process_movement(delta)


func process_input(delta):
    dir = Vector3(0.0, 0.0, 0.0)
    rot = Vector2(0.0, 0.0)
    zoom = 0.0
    if Input.is_key_pressed(KEY_SHIFT):
        speed_mult = 3.0
    else:
        speed_mult = 1.0
    if Input.is_action_pressed("ui_up"):
        if Input.is_key_pressed(KEY_CONTROL):
            zoom -= 1
        else:
            dir.z -= 1
    if Input.is_action_pressed("ui_down"):
        if Input.is_key_pressed(KEY_CONTROL):
            zoom += 1
        else:
            dir.z += 1
    if Input.is_action_pressed("ui_left"):
        if Input.is_key_pressed(KEY_CONTROL):
            dir.x -= 1
        else:
            rot.x += 1
    if Input.is_action_pressed("ui_right"):
        if Input.is_key_pressed(KEY_CONTROL):
            dir.x += 1
        else:
            rot.x -= 1
    if Input.is_action_pressed("ui_page_up"):
        if Input.is_key_pressed(KEY_CONTROL):
            dir.y += 1
        else:
            rot.y += 1
    if Input.is_action_pressed("ui_page_down"):
        if Input.is_key_pressed(KEY_CONTROL):
            dir.y -= 1
        else:
            rot.y -= 1
    dir = dir.normalized()
    rot = rot.normalized()
    zoom = sign(zoom)
    if self.tablet != null and Input.is_action_pressed("ui_home"):
         self.change_tablet_visibility = true




func process_movement(delta):
    var accel
    if dir.dot(vel) > 0.0:
        accel = ACCEL
    else:
        accel = DEACCEL
    var u = clamp(accel * delta, 0.0, 1.0)
    vel = vel.linear_interpolate(self.transform.basis * self.rotation_helper.transform.basis * dir * WALK_SPEED * speed_mult, u)
    vel = self.move_and_slide(vel, Vector3(0, 0, 0), false, 4, deg2rad(MAX_SLOPE_ANGLE))
    self.rotation_helper.rotate_x(SPIN_SPEED * speed_mult * deg2rad(rot.y))
    rotation_helper.rotation_degrees.x = clamp(rotation_helper.rotation_degrees.x, -90.0, 90.0)
    self.rotate_y(SPIN_SPEED * speed_mult * deg2rad(rot.x))
    camera.fov += ZOOM_SPEED * speed_mult * zoom
    camera.fov = clamp(camera.fov, 15.0, 135.0)
    if self.tablet != null and self.change_tablet_visibility:
        self.change_tablet_visibility = false
        var r = self.tablet.get_translation()
        self.tablet.translation = Vector3(r.x, r.y, -r.z)
        #var tween = Tween.new()
        #tween.interpolate_property(self.tablet, NodePath("translation"), r, Vector3(r.x, r.y, -r.z), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        #tween.start()


