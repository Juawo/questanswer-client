extends Control

var card_scene: PackedScene = preload("res://scenes/card.tscn")
var card_data_obj: CardData
@onready var control_carousel: Control = $CarouselContainer/Control

func _ready() -> void:
	populate_carousel(control_carousel)

func populate_carousel(carousel: Control):
	for card_dictionary in SessionState.cards_from_database:
		var new_scene = card_scene.instantiate()
		carousel.add_child(new_scene)
		new_scene.populate_front(card_data_obj)
