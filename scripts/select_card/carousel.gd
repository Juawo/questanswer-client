extends Control

signal finished_populate
signal selected_index_changed(new_index : int)
signal number_of_child_changed(new_value : int)

# TODO : Carousel say yo select_card the number of cards in the carouselcontainer and the selected index

var card_scene: PackedScene = preload("res://scenes/card.tscn")
var card_modal_scene: PackedScene = preload("res://scenes/card_modal.tscn")

@onready var control_carousel: Control = $CarouselContainer/Control
@onready var carousel_container: CarouselContainer = $CarouselContainer

func _ready() -> void:
	var root = get_tree().current_scene
	root.random_index_sorted.connect(carousel_container.update_selected_index)
	
	carousel_container._on_selected_index_changed.connect(on_selected_index_changed)
	carousel_container._on_number_of_child_changed.connect(on_number_of_child_changed)

func on_selected_index_changed(new_index : int) -> void :
	selected_index_changed.emit(new_index)
	
func on_number_of_child_changed(new_count : int) -> void :
	number_of_child_changed.emit(new_count)

func populate_carousel(carousel: Control):
	for card in SessionState.cards_from_database:
		var new_scene = card_scene.instantiate()
		carousel.add_child(new_scene)
		new_scene.current_mode = new_scene.MODE.CAROUSEL
		new_scene.card_selected.connect(_on_card_selected)
		new_scene.back.mouse_filter = 2
		new_scene.populate_front(card)
	finished_populate.emit()
	number_of_child_changed.emit(control_carousel.get_child_count())
	print("POPULATE - NUM : ", control_carousel.get_child_count())

func _on_card_selected(card_data: CardData):
	var modal_instace = card_modal_scene.instantiate()
	get_tree().root.add_child(modal_instace)
	modal_instace.card_was_played.connect(remove_card)
	modal_instace.scroll_carousel.connect(carousel_container.switch_control_state)
	modal_instace.set_card_data(card_data)

func remove_card():
	var index = carousel_container.selected_index
	var selected_node = control_carousel.get_child(index)
	
	control_carousel.remove_child(selected_node)
	var card_index = selected_node.card_data.id
	var index_to_remove = SessionState.cards_from_database.find_custom(
		func(card) : return card.id == card_index
	)
	
	if(index_to_remove != -1) :
		SessionState.cards_from_database.remove_at(index_to_remove)
	selected_node.queue_free()
	
	var new_count = control_carousel.get_child_count()
	carousel_container.selected_index = clamp(index, 0,new_count-1)
	carousel_container.update_selected_index(carousel_container.selected_index)
	
	number_of_child_changed.emit(new_count)
