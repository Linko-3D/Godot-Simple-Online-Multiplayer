extends Node


@export var player : PackedScene
@export var map : PackedScene

var upnp = UPNP.new()


func _ready() -> void:
	upnp.discover()
	upnp.add_port_mapping(12345)
	%PublicIP.text = upnp.query_external_address()

	_on_join_button_pressed() # The clients will automatically join if a local server is created

	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()


func _on_viewport_size_changed():
	%Say.size.x = get_viewport().size.x / 2
	%Say.position.x = get_viewport().size.x / 4
	%Say.position.y = (get_viewport().size.y / 4) * 3


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		%Say.visible = !%Say.visible
		if %Say.visible:
			%MessagesBox.show()
			%MessagesDisapearTimer.stop()
		else:
			%MessagesDisapearTimer.start()
			
		if %Say.text != "" and not %Say.visible:
			send_message.rpc(multiplayer.get_unique_id(), %Say.text)
			%Say.text = ""


func _on_host_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(12345)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_disconnected.connect(remove_player)

	%Server.show()

	load_game()


func _on_join_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(%To.text, 12345)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(load_game)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)


func _on_to_text_submitted(new_text: String) -> void:
	_on_join_button_pressed() 


func load_game():
	%Menu.hide()

	if multiplayer.is_server():
		%Map.add_child(map.instantiate())
	else:
		%Lobby.show()


func _on_connection_failed():
	pass


func _on_server_disconnected():
	%Menu.show()
	%Lobby.hide()

	if %Map.get_child(0):
		%Map.get_child(0).queue_free()


@rpc("any_peer")
func add_player(id):
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	%Players.add_child(player_instance)


@rpc("any_peer")
func remove_player(id):
	if %Players.get_node(str(id)):
		%Players.get_node(str(id)).queue_free()


@rpc("call_local", "any_peer")
func send_message(id, message):
	%MessagesBox.show()
	var label = Label.new()
	label.modulate = Color(1, 0.75, 0)
	if id == 1:
		label.modulate = Color.GREEN
		label.text = "SERVER: " + message
	else:
		label.text = str(id) + ": " + message
	%Messages.get_child(6).queue_free()
	%Messages.add_child(label)
	%Messages.move_child(label, 0)
	%MessagesDisapearTimer.start()


func _on_enter_button_pressed() -> void:
	add_player.rpc_id(1, multiplayer.get_unique_id())
	%Lobby.hide()


func _on_messages_disapear_timer_timeout() -> void:
	%MessagesBox.hide()
