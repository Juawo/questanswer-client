extends Control

var card_scene: PackedScene = preload("res://scenes/card.tscn")

@onready var control_carousel: Control = $CarouselContainer/Control
@onready var carousel_container: CarouselContainer = $CarouselContainer

func _ready() -> void:
	populate_carousel(control_carousel)

func populate_carousel(carousel: Control):
	for card in SessionState.cards_from_database:
		var new_scene = card_scene.instantiate()
		carousel.add_child(new_scene)
		new_scene.current_mode = new_scene.Mode.CAROUSEL
		new_scene.populate_front(card)

#func remove_selected_card():
	#var card = control_carousel.get_child(carousel_container.selected_index)
	#control_carousel.remove_child(card)
	#print("CARTA REMOVIDA")
