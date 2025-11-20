extends CharacterBody3D

@onready var anim_pl: AnimationPlayer = $AnimationPlayer
@onready var shape_low: ShapeCast3D = $ShapeHolder/ShapeLow
@onready var shape_high: ShapeCast3D = $ShapeHolder/ShapeHigh
@onready var shape_feet: ShapeCast3D = $ShapeHolder/ShapeFeet
@onready var shape_low_fow: ShapeCast3D = $ShapeHolder/ShapeLowFow
@onready var shape_low_back: ShapeCast3D = $ShapeHolder/ShapeLowBack



@onready var mark_j_1: Marker3D = $mark_holder/MarkJump1
@onready var mark_j_2: Marker3D = $mark_holder/MarkJump2
@onready var mark_f_1: Marker3D = $mark_holder/MarkFall1
@onready var mark_f_2: Marker3D = $mark_holder/MarkFall2




const tile_long := 2.0
const tile_wide := 0.6
const JUMP_VELOCITY = 12.5

var is_jump := false
var dir_is_foward : bool = true
var fall_start_pos : Vector3

var dir_idle : String

var may_move : bool = false
var time_to_move_l_o_r := 0.2
var time_to_move_f_o_b := 0.2

# Механизм положений _______
enum Sts {IDLE, WALK_L, WALK_R, WALK_F, WALK_B, JUMP, FALL, JUMP_F}
var st := Sts.IDLE
#___________________________


func _physics_process(delta: float) -> void:
	if not is_on_floor() :
		velocity += get_gravity() * delta * 12

	match st:
		Sts.IDLE:
			idle()
		Sts.WALK_L:
			walk_l()
		Sts.WALK_R:
			walk_r()
		Sts.WALK_F:
			walk_f()
		Sts.WALK_B:
			walk_b()
		Sts.JUMP:
			jump()
		Sts.FALL:
			fall()
		Sts.JUMP_F:
			jump_f()

	move_and_slide()


func _input(_event: InputEvent) -> void:

	if Input.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()



func move(direction : String):
	if may_move == false:
		may_move = !may_move

# Само движение
		if direction == "left":
			get_tree().create_tween().tween_property(self, "position", self.position - Vector3(tile_long, 0, 0), time_to_move_l_o_r)
		if direction == "right":
			get_tree().create_tween().tween_property(self, "position", self.position + Vector3(tile_long, 0, 0), time_to_move_l_o_r)
		if direction == "foward":
			get_tree().create_tween().tween_property(self, "position", self.position + Vector3(0, 0, tile_wide), time_to_move_l_o_r)
		if direction == "back":
			get_tree().create_tween().tween_property(self, "position", self.position - Vector3(0, 0, tile_wide), time_to_move_l_o_r)

		anim_pl.play(direction)
		await get_tree().create_timer(time_to_move_l_o_r).timeout

		may_move = !may_move


func chan_st(newSt):
	st = newSt


func idle():
	print("idle")
	if shape_feet.is_colliding() == false:
		chan_st(Sts.FALL)
	if Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		chan_st(Sts.WALK_L)
	if Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		chan_st(Sts.WALK_R)
	if Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down"):
		dir_idle = "back"
		if Input.is_action_just_pressed("ui_accept"):
			if shape_low.is_colliding() == true and shape_high.is_colliding() == false:
				chan_st(Sts.JUMP)
	if !Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		dir_idle = "foward"
		if shape_low_fow.is_colliding():
			chan_st(Sts.WALK_F)
		if Input.is_action_just_pressed("ui_accept"):
			chan_st(Sts.JUMP_F)

	anim_pl.play(dir_idle)

func walk_l():
	if shape_feet.is_colliding() == false:
		chan_st(Sts.FALL)
	print("left")
	if Input.is_action_pressed("ui_left"):
		move("left")
		if Input.is_action_pressed("ui_right"):
			dir_idle = "left_s"
			chan_st(Sts.IDLE)
	elif Input.is_action_just_released("ui_left") and !Input.is_action_pressed("ui_right"):
		dir_idle = "left_s"
		chan_st(Sts.IDLE)
	elif Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		chan_st(Sts.WALK_R)



func walk_r():
	print("right")
	if shape_feet.is_colliding() == false:
		chan_st(Sts.FALL)
	if Input.is_action_pressed("ui_right"):
		move("right")
		if Input.is_action_pressed("ui_left"):
			dir_idle = "foward"
			chan_st(Sts.IDLE)
	elif Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		chan_st(Sts.WALK_L)
	elif Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		dir_idle = "right_s"
		chan_st(Sts.IDLE)


func walk_f():
	print("fffffff")
	if shape_feet.is_colliding() == false:
		chan_st(Sts.FALL)
	if Input.is_action_pressed("ui_down"):
		move("foward")
		if Input.is_action_pressed("ui_up") or !shape_low_fow.is_colliding():
			dir_idle = "foward"
			chan_st(Sts.IDLE)
	elif Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down"):
		chan_st(Sts.WALK_B)
	elif Input.is_action_just_released("ui_down") or !shape_low_fow.is_colliding() and !Input.is_action_pressed("ui_up"):
		dir_idle = "foward"
		chan_st(Sts.IDLE)

func walk_b():
	print("back")
	if shape_feet.is_colliding() == false:
		chan_st(Sts.FALL)
	if Input.is_action_pressed("ui_right"):
		move("right")
		if Input.is_action_pressed("ui_left"):
			dir_idle = "right_s"
			chan_st(Sts.IDLE)
	elif Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		chan_st(Sts.WALK_L)
	elif Input.is_action_just_released("ui_right") and !Input.is_action_pressed("ui_left"):
		dir_idle = "right_s"
		chan_st(Sts.IDLE)


func jump():
	print("jump")
	if is_jump != true:
		is_jump = !is_jump
		anim_pl.play("jump_b")
		var mid_pos = mark_j_1.global_position
		var fin_pos = mark_j_2.global_position
		get_tree().create_tween().tween_property(self, "position", mid_pos, time_to_move_f_o_b*2/3)
		await get_tree().create_timer(time_to_move_f_o_b*2/3).timeout
		get_tree().create_tween().tween_property(self, "position", fin_pos, time_to_move_f_o_b/3)
		await get_tree().create_timer(time_to_move_f_o_b*2/3).timeout
		#may_move = !may_move
		dir_idle = "back"
		is_jump = !is_jump
		chan_st(Sts.IDLE)


func fall():
	#print("AAAAAAAAAAAAAAAAAAAAAAAA")
	if is_jump != true:
		print("A")
		is_jump = !is_jump
		anim_pl.play("jump_f")
		fall_start_pos = self.position
	if shape_feet.is_colliding() == true:
		var difference = self.position - fall_start_pos
		print(difference)
		is_jump = !is_jump
		dir_idle = "foward"
		chan_st(Sts.IDLE)

func jump_f():
	if is_jump != true:
		is_jump = !is_jump
		anim_pl.play("jump_f")
		var mid_pos = mark_f_1.global_position
		var fin_pos = mark_f_2.global_position
		get_tree().create_tween().tween_property(self, "position", mid_pos, time_to_move_f_o_b*2/3)
		await get_tree().create_timer(time_to_move_f_o_b*2/3).timeout
		get_tree().create_tween().tween_property(self, "position", fin_pos, time_to_move_f_o_b/3)
		await get_tree().create_timer(time_to_move_f_o_b*2/3).timeout

		dir_idle = "foward"
		is_jump = !is_jump
		chan_st(Sts.FALL)
