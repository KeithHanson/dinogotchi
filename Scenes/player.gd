extends CharacterBody3D
@export var original_transformation:Transform3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Locomotion Settings
@export var speed = 5
@export var jump_speed = 5
@export var mouse_sensitivity = 0.002
@export var turn_speed = 3
@export var sprint_multiplier = 5

#Stats
@export var growth = 10
@export var maxGrowth = 100
@export var growthRate = 1

@export var maxHP = 100
@export var currentHP = 100
@export var healingRate = 1

@export var currentStamina = 100
@export var maxStamina = 100
@export var sprintDrainRate = 1
@export var staminaRecoveryRate = 5

@export var currentHunger = 0
@export var maxHunger = 100
@export var hungerRate = 0.1

@export var currentThirst = 0
@export var maxThirst = 100
@export var thirstRate = 0.1

#UI
@export var growthValueLabel : Label
@export var growthMaxLabel : Label

@export var hpValueLabel : Label
@export var hpMaxLabel : Label

@export var staminaValueLabel : Label
@export var staminaMaxLabel : Label

@export var thirstValueLabel : Label
@export var thirstMaxLabel : Label

@export var hungerValueLabel : Label
@export var hungerMaxLabel : Label

func _ready():	
	#Normally, we'll want to load in what kind of stats and such to display
	#For now, this'll do for play testing.
	self.original_transformation = self.transform

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
	
	if Input.is_action_pressed("sprint") and self.currentStamina > 0:
		current_speed = speed * sprint_multiplier
		self.currentStamina -= delta * 10
		
		if self.currentStamina < 0:
			self.currentStamina = 0
		
	if not Input.is_action_pressed("sprint") or self.currentStamina <= 0:
		current_speed = speed
	
	velocity.x = movement_dir.x * current_speed
	velocity.z = movement_dir.z * current_speed
	
	move_and_slide()
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed

func update_all_ui():
	self.growthValueLabel.text = str(self.growth).pad_decimals(2)
	self.hpValueLabel.text = str(self.currentHP).pad_decimals(2)
	self.staminaValueLabel.text = str(self.currentStamina).pad_decimals(2)
	self.hungerValueLabel.text = str(self.currentHunger).pad_decimals(2)
	self.thirstValueLabel.text = str(self.currentThirst).pad_decimals(2)

func adjust_all_player_properties_on_tick():
	self.growth += self.growthRate
	self.currentHunger += self.hungerRate
	self.currentThirst += self.thirstRate
	
	self.currentHP += self.healingRate
	
	if self.currentHP > self.maxHP:
		self.currentHP = self.maxHP
	
	if not Input.is_action_pressed("sprint") and self.currentStamina < self.maxStamina:
		self.currentStamina += self.staminaRecoveryRate
		
		if self.currentStamina > self.maxStamina:
			self.currentStamina = self.maxStamina

func apply_all_player_properties_on_tick():
	var _scale_to_apply = self.growth / float(self.maxGrowth)
	

func _on_tick_timer_timeout():
	self.adjust_all_player_properties_on_tick()
	self.apply_all_player_properties_on_tick()
	
	self.update_all_ui()
