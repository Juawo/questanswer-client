extends Control

var card_scene: PackedScene = preload("res://scenes/card.tscn")
var card_modal_scene: PackedScene = preload("res://scenes/card_modal.tscn")

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

func remove_card_by_id(card_id: int):
	for card_node in control_carousel.get_children():
		if !is_instance_valid(card_node):
			print("Erro ao remover carta")
			return
		if card_node.id == card_id:
			card_node.queue_free()
			print("CARTA REMOVIDA")
			return
