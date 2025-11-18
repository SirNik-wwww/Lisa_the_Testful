extends CharacterBody3D

@onready var anim_pl: AnimatedSprite3D = $AnimatedSprite3D
const SPEED = 5.0
const JUMP_VELOCITY = 12.5
var dir_is_foward : bool = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 4

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if $ShapeCast3D.is_colliding() == true:
			velocity.y += JUMP_VELOCITY


	if Input.is_action_pressed("ui_left"):
		anim_pl.play("left")
	if Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		anim_pl.play("left_s")

	if Input.is_action_pressed("ui_right"):
		anim_pl.play("right")
	if Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		anim_pl.play("right_s")

	if Input.is_action_pressed("ui_left") != true and Input.is_action_pressed("ui_right") != true:
		if Input.is_action_pressed("ui_up"):
			anim_pl.play("back")
			
		if Input.is_action_pressed("ui_down"):
			anim_pl.play("foward")
