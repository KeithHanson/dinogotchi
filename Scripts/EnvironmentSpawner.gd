extends Node3D

@export var maxDuplicates: Array[int]
@export var modelsToDuplicate: Array[PackedScene]

@export var minMoveDistance = -30
@export var maxMoveDistance = 30

func _ready():
	print("Ready.")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	print(len(modelsToDuplicate))
	var index = 0
	
	for model in modelsToDuplicate:
		if model == null:
			continue
		
		print("Duplicating...")
		for n in maxDuplicates[index]:
			var newModel = model.instantiate() as Node3D
			
			newModel.position = Vector3(randi_range(minMoveDistance,maxMoveDistance), 0, randi_range(minMoveDistance,maxMoveDistance))
			newModel.rotation = Vector3(0, randi_range(0,360), 0)
			add_child(newModel)
			print("Added Child")
			print(newModel.position)
		index += 1

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	#get_tree().set_input_as_handled()

func _init():
	pass
