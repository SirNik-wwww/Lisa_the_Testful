extends CharacterBody3D

@onready var anim_pl: AnimatedSprite3D = $AnimatedSprite3D
const SPEED = 5.0
const JUMP_VELOCITY = 12.5
var dir_is_foward : bool = true
var may_move : bool = false
var time_to_move_l_o_r := 0.5
var action_released : bool = true

@onready var m_holder: Node3D = $MarkHolder
@onready var m_right: Marker3D = $MarkHolder/MarkerRight
@onready var m_left: Marker3D = $MarkHolder/MarkerLeft




func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 4

	move_and_slide()



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if $ShapeCast3D.is_colliding() == true:
			velocity.y += JUMP_VELOCITY

# Код из холи реал
		#var terminal_back = Vector3(backdoor.position.x, backdoor.position.y +4, backdoor.position.z)
		#get_tree().create_tween().tween_property(backdoor, "position", terminal_back, 0.4)
		#var terminal_1 = Vector3(static_body_3d.position.x, static_body_3d.position.y +5.1, static_body_3d.position.z)
		#get_tree().create_tween().tween_property(static_body_3d, "position", terminal_1, 0.4)


	if Input.is_action_pressed("ui_left"):
		move_left_right("left")
	if Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		action_released = true
		#anim_pl.play("left_s")

	if Input.is_action_pressed("ui_right"):
		move_left_right("right")
	if Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		action_released = true

	if Input.is_action_pressed("ui_left") != true and Input.is_action_pressed("ui_right") != true:
		if Input.is_action_pressed("ui_up"):
			anim_pl.play("back")
			
		if Input.is_action_pressed("ui_down"):
			anim_pl.play("foward")


	if Input.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()


func move_left_right(direction : String):
	if may_move == false:
		may_move = !may_move
		var next_pos_left := m_left.global_position
		var next_pos_rigth := m_right.global_position
		if direction == "left":
			get_tree().create_tween().tween_property(self, "position", next_pos_left, time_to_move_l_o_r)
		if direction == "right":
			get_tree().create_tween().tween_property(self, "position", next_pos_rigth, time_to_move_l_o_r)
		anim_pl.play(direction)
		await get_tree().create_timer(time_to_move_l_o_r).timeout
		if action_released == true:
			var dir_name = direction + "_s"
			anim_pl.play(dir_name)
		may_move = !may_move
		
