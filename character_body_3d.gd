extends CharacterBody3D

var acceleration = 0.1
var deceleration = 0.25
var gravity = 12.0
var _speed = 6
@onready var anim_pl: AnimatedSprite3D = $AnimatedSprite3D



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta


	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = velocity.x * direction.x * _speed
		velocity.z = velocity.z * direction.z * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

	move_and_slide()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if $ShapeCast3D.is_colliding() == true:
			velocity.y += 7
	if Input.is_action_pressed("ui_left"):
		anim_pl.play("left")

	if Input.is_action_just_released("ui_left"):
		anim_pl.stop()

	if Input.is_action_pressed("ui_right"):
		anim_pl.play("right")
