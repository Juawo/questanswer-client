extends Control

func _ready() -> void:
	print($CarouselContainer/Control.position.x)
	print($CarouselContainer/Control.position.y)

func _on_button_pressed() -> void:
	$CarouselContainer._left()
	
func _on_button_2_pressed() -> void:
	$CarouselContainer._rigth()
