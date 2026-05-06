extends CanvasLayer

func _on_Button0_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.soaked:
		return
		
	if NecessityBars.onbath:
		return true
	
	$MapContainer.visible = false
	var button_room = 0
	var current_room = get_room_number(AnimationController.current_room)
	AnimationController.travel(current_room, button_room)

func _on_Button1_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.onbath:
		return true
	if NecessityBars.soaked:
		return
		
	$MapContainer.visible = false
	var button_room = 1
	var current_room = get_room_number(AnimationController.current_room)
	AnimationController.travel(current_room, button_room)

func _on_Button2_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.soaked:
		return		
	if NecessityBars.onbath:
		return true
	
	$MapContainer.visible = false
	var button_room = 2
	var current_room = get_room_number(AnimationController.current_room)
	AnimationController.travel(current_room, button_room)

func _on_Button3_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.soaked:
		return	
	if NecessityBars.onbath:
		return true
	
	$MapContainer.visible = false
	var button_room = 3
	var current_room = get_room_number(AnimationController.current_room)
	AnimationController.travel(current_room, button_room)
	
func _on_Button4_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.soaked:
		return
	if NecessityBars.onbath:
		return true
		
	$MapContainer.visible = false
	var button_room = 4
	var current_room = get_room_number(AnimationController.current_room)
	AnimationController.travel(current_room, button_room)

func _on_Button5_pressed():
	if check_if_can_press_button():
		return

	if NecessityBars.soaked:
		return
	if NecessityBars.onbath:
		return true

	$MapContainer.visible = false
	var button_room = 5
	var current_room = get_room_number(AnimationController.current_room)
	AnimationController.travel(current_room, button_room)

func _process(delta: float) -> void:
#	Set_Disabled_Button()
	
	$BathroomProgress.value = NecessityBars.banheiro
	$KitchenProgress.value = NecessityBars.fome
	$BedroomProgress.value = NecessityBars.energia
	$YardProgress.value = NecessityBars.diversao
	
	if check_if_can_press_button():
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
		
#
#func Set_Disabled_Button():
#	if(AnimationController.status == "Hidratona" or AnimationController.status == "Match3" or AnimationController.status == "DoiAqui" or AnimationController.current_room == null):
#		$"Button-0".disabled = true
#		$"Button-1".disabled = true
#		$"Button-2".disabled = true
#		$"Button-3".disabled = true
#		$"Button-4".disabled = true
#		return
#
#	if(AnimationController.current_room.room_id == 0 or AnimationController.current_room.room_id == 5):
#		$"Button-0".disabled = true
#		$"Button-1".disabled = false
#		$"Button-2".disabled = false
#		$"Button-3".disabled = false
#		$"Button-4".disabled = false
#	elif(AnimationController.current_room.room_id == 1):
#		$"Button-0".disabled = false
#		$"Button-1".disabled = true
#		$"Button-2".disabled = false
#		$"Button-3".disabled = false
#		$"Button-4".disabled = false
#	elif(AnimationController.current_room.room_id == 2):
#		$"Button-0".disabled = false
#		$"Button-1".disabled = false
#		$"Button-2".disabled = true
#		$"Button-3".disabled = false
#		$"Button-4".disabled = false
#	elif(AnimationController.current_room.room_id == 3):
#		$"Button-0".disabled = false
#		$"Button-1".disabled = false
#		$"Button-2".disabled = false
#		$"Button-3".disabled = true
#		$"Button-4".disabled = false
#	elif(AnimationController.current_room.room_id == 4):
#		$"Button-0".disabled = false
#		$"Button-1".disabled = false
#		$"Button-2".disabled = false
#		$"Button-3".disabled = false
#		$"Button-4".disabled = true

func check_if_can_press_button():
	if AnimationController.isTravelling():
		return true
	if AnimationController.is_playing():
		return true
	if CharacterController.is_playing():
		return true
	if NecessityBars.peeing:
		return true
	
	return false

func get_room_number(room):
	print(room)
	if(!room):
		print(room)
		return 0
	
	print(room.room_id)
	return room.room_id
	
	return
	if(room.name == "Yard"):
		return 0
	if(room.name == "LivingRoom"):
		return 1
	if(room.name == "Kitchen"):
		return 2
	if(room.name == "Bedroom"):
		return 3
	if(room.name == "Bathroom"):
		return 4
	


func _on_left_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.soaked:
		return
		
	if NecessityBars.onbath:
		return true
	
	var current_room = get_room_number(AnimationController.current_room)
	var button_room = current_room - 1
	
	if current_room == 0:
		return
	
	AnimationController.travel(current_room, button_room)
	
	pass


func _on_right_pressed():
	if(check_if_can_press_button()):
		return
	
	if NecessityBars.soaked:
		return
		
	if NecessityBars.onbath:
		return true
	
	var current_room = get_room_number(AnimationController.current_room)
	var button_room = current_room + 1
	
	if current_room == 5:
		AnimationController.travel(current_room, 1)
		return
	
	AnimationController.travel(current_room, button_room)
	
	pass


func _on_MenuButton_pressed():
	$MapContainer.visible = !$MapContainer.visible

