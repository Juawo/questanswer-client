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
		new_scene.current_mode = new_scene.MODE.CAROUSEL
		new_scene.card_selected.connect(_on_card_selected)
		new_scene.populate_front(card)

func _on_card_selected(card_data: CardData):
	var modal_instace = card_modal_scene.instantiate()
	get_tree().root.add_child(modal_instace)
	modal_instace.card_was_played.connect(remove_card_by_id)
	modal_instace.scroll_carousel.connect(carousel_container.switch_control_state)
	modal_instace.set_card_data(card_data)

func remove_card_by_id(card_id: int):
	print("ID:", card_id)
	var selected_node = control_carousel.get_children()[carousel_container.selected_index]
	selected_node.queue_free()
	#for card_node in control_carousel.get_children():
		#if !is_instance_valid(card_node):
			#print("Erro ao remover carta")
			#continue
		#if card_node == carousel_container.get_child(carousel_container.selected_index):
			#card_node.queue_free()
			#print("CARTA REMOVIDA")
			#carousel_container.selected_index += 1
			#return
