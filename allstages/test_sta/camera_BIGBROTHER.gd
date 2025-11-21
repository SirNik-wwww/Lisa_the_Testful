extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at($"../Bread".position)
	
	if Input.is_action_just_pressed("+debug_q"):
		print("WWewerdwewewewwdde")
		if current == true:
			$".".current = false
			$"../Bread/Camera3D".current = true
		else :
			$".".current = true
			$"../Bread/Camera3D".current = false
