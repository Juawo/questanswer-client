extends Control

signal finished_populate

var card_scene: PackedScene = preload("res://scenes/card.tscn")
var card_modal_scene: PackedScene = preload("res://scenes/card_modal.tscn")

@onready var control_carousel: Control = $CarouselContainer/Control
@onready var carousel_container: CarouselContainer = $CarouselContainer

func _ready() -> void:
	var root = get_tree().current_scene
	root.random_index_sorted.connect(carousel_container.update_selected_index)

func populate_carousel(carousel: Control):
	for card in SessionState.cards_from_database:
		var new_scene = card_scene.instantiate()
		carousel.add_child(new_scene)
		new_scene.current_mode = new_scene.MODE.CAROUSEL
		new_scene.card_selected.connect(_on_card_selected)
		new_scene.back.mouse_filter = 2
		new_scene.populate_front(card)
	emit_signal("finished_populate")

func _on_card_selected(card_data: CardData):
	var modal_instace = card_modal_scene.instantiate()
	get_tree().root.add_child(modal_instace)
	modal_instace.card_was_played.connect(remove_card)
	modal_instace.scroll_carousel.connect(carousel_container.switch_control_state)
	modal_instace.set_card_data(card_data)

func remove_card():
	var selected_node = control_carousel.get_children()[carousel_container.selected_index]
	selected_node.queue_free()
