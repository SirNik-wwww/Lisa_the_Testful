extends CharacterBody3D

const CELL_SIZE = 64
var target_position = Vector2()
var is_moving = false
var input_vector : Vector3i
var move_action : Array = ["ui_up", "ui_down", "ui_left", "ui_right"] 
var _speed : float = 6.0

func _ready():
	target_position = position

func _process(delta: float) -> void:
	move_and_slide()


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_up"):
		velocity.z = _speed * -1
	if Input.action_release("ui_up"):
		velocity.z = 0
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1.0
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1.0
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1.0
	#
	#for action in move_action:
		#if Input.is_action_pressed(action):
			#velocity.x = input_vector * _speed
			##print("sssssss")
