extends CharacterBody2D


const SPEED = 400.0


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	%DisplayAuthority.visible = is_multiplayer_authority()

	if get_tree().get_nodes_in_group("spawn_point"):
		position = get_tree().get_nodes_in_group("spawn_point")[0].position


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return

	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
