extends Control

signal random_index_sorted(random_index : int)

@onready var id_card_label: Label = $MarginContainer/VBoxContainer/footer/PanelContainer/MarginContainer/Label
@onready var carousel_container: CarouselContainer = $MarginContainer/VBoxContainer/carousel/CarouselContainer
@onready var carousel: Control = $MarginContainer/VBoxContainer/carousel
@onready var played_cards_ui: Label = $MarginContainer/VBoxContainer/header/header/played_cards/MarginContainer/HBoxContainer/MarginContainer/Label
@onready var empty_cards_label: Label = $MarginContainer/VBoxContainer/empty_cards_label
@onready var questioner_time_screen: Control = $questioner_time_screen
@onready var options_panel: Control = $options_panel

var selected_index : int
var random_index : int
var num_card_in_carrousel : int : set = set_num_cards

func _ready() -> void:
	randomize()
	carousel.card_played.connect(_on_card_played)
	carousel.finished_populate.connect(carousel_container.setup)
	carousel.selected_index_changed.connect(_on_selected_index_changed)
	carousel.number_of_child_changed.connect(_on_number_of_child_changed)
	carousel.populate_carousel(carousel.control_carousel)
	options_panel.panel_closed.connect(_on_options_panel_closed)
	questioner_time_screen.show_screen()

func _on_random_btn_pressed() -> void:
	var num_current_cards = carousel_container.position_offset_node.get_child_count()
	if num_current_cards <= 1:
		return

	# Sorteia um novo índice, garantindo que seja diferente do atual
	random_index = randi_range(0, num_current_cards - 1) # Correção: o índice máximo é size - 1
	AudioManager.play_random_card()
	while random_index == selected_index:
		random_index = randi_range(0, num_current_cards -1)
	emit_signal("random_index_sorted", random_index)

func _on_selected_index_changed(new_index : int) -> void :
	selected_index = new_index
	update_index_ui()

func _on_number_of_child_changed(number_child : int) -> void :
	num_card_in_carrousel = number_child
	update_played_ui()
	update_index_ui()

func set_num_cards(new_value) -> void :
	if (new_value <= 0) :
		num_card_in_carrousel = 0
		empty_cards_label.visible = true
		carousel.visible = false
	else :
		num_card_in_carrousel = new_value
		empty_cards_label.visible = false
		carousel.visible = true

func update_index_ui() -> void :
	if num_card_in_carrousel <= 0 :
		id_card_label.text = "0/0"
	id_card_label.text = "%s/%s" % [selected_index + 1, num_card_in_carrousel]

func update_played_ui() -> void :
	if num_card_in_carrousel <= 0 :
		played_cards_ui.text = "%s/%s" % [len(SaveManager.played_cards_ids),len(SaveManager.played_cards_ids)]
	else :
		played_cards_ui.text = "%s/%s" % [len(SaveManager.played_cards_ids),SessionState.num_cards]
 
func _on_card_played() -> void :
	questioner_time_screen.show_screen()

func _on_options_btn_pressed() -> void:
	options_panel.show_panel()
	carousel.switch_scroll_state(false)

func _on_options_panel_closed() -> void :
	carousel.switch_scroll_state(true)
