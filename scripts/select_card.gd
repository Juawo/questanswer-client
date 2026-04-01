extends Control

signal random_index_sorted(random_index : int)

@onready var id_card_label: Label = $MarginContainer/VBoxContainer/footer/PanelContainer/MarginContainer/Label
@onready var carousel_container: CarouselContainer = $MarginContainer/VBoxContainer/carousel/CarouselContainer
@onready var carousel: Control = $MarginContainer/VBoxContainer/carousel
@onready var played_cards_ui: Label = $MarginContainer/VBoxContainer/header/header/played_cards/MarginContainer/HBoxContainer/MarginContainer/Label

var selected_index : int;
var random_index : int;
var num_card_in_carrousel : int

func _ready() -> void:
	randomize()
	carousel.finished_populate.connect(carousel_container.setup)
	carousel.populate_carousel(carousel.control_carousel)
	
func _process(_delta: float) -> void:
	selected_index = carousel_container.selected_index
	num_card_in_carrousel = carousel_container.get_child(0).get_child_count()
	id_card_label.text = "%s/%s" % [selected_index + 1, num_card_in_carrousel]
	played_cards_ui.text = "%s/%s" % [len(SaveManager.played_cards_ids),SessionState.num_cards]

func _on_random_btn_pressed() -> void:
	var num_current_cards = carousel_container.position_offset_node.get_child_count()
	
	if num_current_cards <= 1:
		return
		
	# Sorteia um novo índice, garantindo que seja diferente do atual
	random_index = randi_range(0, num_current_cards - 1) # Correção: o índice máximo é size - 1
	while random_index == selected_index:
		random_index = randi_range(0, num_current_cards -1)
	
	emit_signal("random_index_sorted", random_index)
