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

# Here is the key for solve the BUG
func remove_card():
	var index = carousel_container.selected_index
	var selected_node = control_carousel.get_child(index)
	
	control_carousel.remove_child(selected_node)
	selected_node.queue_free()
	
	var new_count = control_carousel.get_child_count()
	carousel_container.selected_index = clamp(index, 0,new_count-1)
	#carousel_container._left();
	carousel_container.update_selected_index(carousel_container.selected_index)
	print("Selected Index : ", carousel_container.selected_index)
	print("Card : ", carousel_container.get_child(0).get_children()[0].card_data.answer)
