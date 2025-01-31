extends CharacterBody2D


const SPEED = 400.0
var can_control = true # Doesn't move the player while chatting

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	%DisplayAuthority.visible = is_multiplayer_authority()

	if get_tree().get_nodes_in_group("spawn_point"):
		position = get_tree().get_nodes_in_group("spawn_point")[0].position


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority() or not can_control: return

	velocity = Input.get_vector("left", "right", "up", "down") * SPEED
	move_and_slide()
