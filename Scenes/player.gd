extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 5
@export var jump_speed = 5
@export var mouse_sensitivity = 0.002
@export var growth = 0.1
@export var turn_speed = 3
@export var sprint_multiplier = 5

func _ready():
	self.transform = self.transform.scaled(Vector3(growth, growth, growth))

func _input(_event):
	pass
#	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
#		rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	if Input.is_action_pressed("rotate_left"):
		rotate_y(self.turn_speed * delta)
		
	if Input.is_action_pressed("rotate_right"):
		rotate_y(-self.turn_speed * delta)
		
	velocity.y += -gravity * delta
	
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	
	var current_speed = 0
	
	if Input.is_action_pressed("sprint"):
		current_speed = speed * sprint_multiplier
		
	if not Input.is_action_pressed("sprint"):
		current_speed = speed
	
	velocity.x = movement_dir.x * current_speed
	velocity.z = movement_dir.z * current_speed
	
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
