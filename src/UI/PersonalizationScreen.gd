extends CanvasLayer

var glass = CharacterController.glass
var variation = CharacterController.variation

func _process(delta: float) -> void:
	if(glass == false and variation == 1):
		$Boy_closet/b1_wo.disabled = true
		$Girl_closet/g1_wo.disabled = true
	if(glass == true and variation == 1):
		$Boy_closet/b1_w.disabled = true
		$Girl_closet/g1_w.disabled = true
	if(glass == false and variation == 2):
		$Boy_closet/b2_wo.disabled = true
		$Girl_closet/g2_wo.disabled = true
	if(glass == true and variation == 2):
		$Boy_closet/b2_w.disabled = true
		$Girl_closet/g2_w.disabled = true

func _on_b1_wo_pressed() -> void:
	$Boy_closet/b1_wo.disabled = true
	$Boy_closet/b1_w.disabled = false
	$Boy_closet/b2_wo.disabled = false
	$Boy_closet/b2_w.disabled = false
	
	glass = false
	variation = 1

func _on_b1_w_pressed() -> void:
	$Boy_closet/b1_wo.disabled = false
	$Boy_closet/b1_w.disabled = true
	$Boy_closet/b2_wo.disabled = false
	$Boy_closet/b2_w.disabled = false
	
	glass = true
	variation = 1

func _on_b2_wo_pressed() -> void:
	$Boy_closet/b1_wo.disabled = false
	$Boy_closet/b1_w.disabled = false
	$Boy_closet/b2_wo.disabled = true
	$Boy_closet/b2_w.disabled = false
	
	glass = false
	variation = 2

func _on_b2_w_pressed() -> void:
	$Boy_closet/b1_wo.disabled = false
	$Boy_closet/b1_w.disabled = false
	$Boy_closet/b2_wo.disabled = false
	$Boy_closet/b2_w.disabled = true
	
	glass = true
	variation = 2

func _on_UseButton_pressed() -> void:
	CharacterController.glass = glass
	CharacterController.variation = variation
	CharacterController.start()
	$Boy_closet.visible = false
	$Girl_closet.visible = false

func _on_Close_pressed() -> void:
	$Boy_closet.visible = false
	$Girl_closet.visible = false

func _on_g1_wo_pressed() -> void:
	$Girl_closet/g1_wo.disabled = true
	$Girl_closet/g1_w.disabled = false
	$Girl_closet/g2_wo.disabled = false
	$Girl_closet/g2_w.disabled = false
	
	glass = false
	variation = 1

func _on_g1_w_pressed() -> void:
	$Girl_closet/g1_wo.disabled = false
	$Girl_closet/g1_w.disabled = true
	$Girl_closet/g2_wo.disabled = false
	$Girl_closet/g2_w.disabled = false
	
	glass = true
	variation = 1

func _on_g2_wo_pressed() -> void:
	$Girl_closet/g1_wo.disabled = false
	$Girl_closet/g1_w.disabled = false
	$Girl_closet/g2_wo.disabled = true
	$Girl_closet/g2_w.disabled = false
	
	glass = false
	variation = 2

func _on_g2_w_pressed() -> void:
	$Girl_closet/g1_wo.disabled = false
	$Girl_closet/g1_w.disabled = false
	$Girl_closet/g2_wo.disabled = false
	$Girl_closet/g2_w.disabled = true
	
	glass = true
	variation = 2
