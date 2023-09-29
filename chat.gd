extends Node

func _ready():
	%InputBox.hide()
	%Messages.hide()

	%InputBox.position.y = (get_viewport().size.y / 4) * 3

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		%InputBox.hide()
		%InputText.text = ""
	
	if Input.is_action_just_pressed("ui_accept"):
		%InputBox.visible = !%InputBox.visible

		if %InputBox.visible == false:
			_on_say_button_pressed()
		else:
			%Messages.show()

func _on_input_text_text_submitted(new_text):
	_on_say_button_pressed()

func _on_say_button_pressed():
	%InputBox.hide()
	%Timer.start()
	if %InputText.text != "":
		send_message.rpc(%InputText.text, str(multiplayer.get_unique_id()))
		%InputText.text = ""

@rpc("call_local", "any_peer")
func send_message(message, playerName):
	var label = Label.new()
	label.text = playerName + ": " + message
	%DisplayedMessages.add_child(label)

	if %DisplayedMessages.get_child_count() > 7:
		%DisplayedMessages.get_child(0).queue_free()

	%Timer.start()
	%Messages.show()

func _on_timer_timeout():
	%Messages.hide()
