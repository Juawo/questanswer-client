extends Control

signal flip_requested
signal close_requested
signal card_played()
signal card_selected(card_data)

enum MODE { CAROUSEL , MODAL }

var current_mode: MODE = MODE.CAROUSEL
var card_data: CardData;
var id : int
var number_of_tips := 10

var card_modal_scene : PackedScene = load("res://scenes/card_modal.tscn")
var is_tip_running : bool = false

@onready var answer: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/term_card/term_card/Label2
@onready var category: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/type_card/MarginContainer/VBoxContainer/Label2
@onready var tips: VBoxContainer = $front/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/tips

@onready var back: TextureButton = $back

@onready var close_btn: TextureButton = $front/MarginContainer/VBoxContainer/header_card/header_card/MarginContainer/close_btn
@onready var error_btn: Button = $front/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/error_btn
@onready var hit_btn: Button = $front/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/hit_btn

func _ready() -> void:
	self.pivot_offset = self.size/2

func populate_front(data: CardData):
	self.card_data = data
	if(is_instance_valid(card_data)):
		answer.text = card_data.answer
		category.text = card_data.category
		for i in range(tips.get_child_count()):
			if i < card_data.tips.size():
				var tip = tips.get_child(i)
				tip.pressed.connect(_on_tip_pressed.bind(tip))
				tip.tip_finished.connect(_on_tip_finished)
				var text_for_tip = "%d. %s" % [i+1, card_data.tips[i]]
				tip.set_tip_text(text_for_tip)

func _on_back_pressed() -> void:
		match current_mode:
			MODE.CAROUSEL:
				emit_signal("card_selected", card_data)
			MODE.MODAL: # animation made in card modal
				emit_signal("flip_requested")

func _on_close_btn_pressed() -> void:
	if current_mode == MODE.MODAL:
		make_unclicable()
		emit_signal("close_requested")
		AudioManager.stop_clock_counting()

func make_unclicable() -> void:
	for child in tips.get_children():
		child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	close_btn.disabled = true
	close_btn.modulate = "#858585"
	hit_btn.disabled = true
	error_btn.disabled = true

func toogle_tips_unclicable(is_unclicable : bool) -> void :
	if is_unclicable :
		for child in tips.get_children():
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else :
		for child in tips.get_children():
			child.mouse_filter = Control.MOUSE_FILTER_STOP
	
func _on_tip_pressed(tip) :
	if !is_tip_running:
		tip.start_tip()
		is_tip_running = true
		toggle_action_btns(true)

func _on_tip_finished():
	is_tip_running = false
	close_btn.disabled = false
	close_btn.modulate = "#ffffff"
	toggle_action_btns(false)
	toogle_tips_unclicable(true)

func toggle_action_btns(is_disabled : bool) -> void:
	error_btn.disabled = is_disabled
	hit_btn.disabled = is_disabled

func _on_error_btn_pressed() -> void:
	AudioManager.play_correct(false)
	if get_used_tips_count() >= number_of_tips :
		SessionState._on_all_player_missed()
		SaveManager.add_played_card(self.card_data.id)
		make_unclicable()
		emit_signal("card_played")
		emit_signal("close_requested")
	else :
		SessionState._on_player_miss()
		toogle_tips_unclicable(false)
		toggle_action_btns(true)

func _on_hit_btn_pressed() -> void:
	AudioManager.play_correct(true)
	SessionState._on_player_hit()
	SaveManager.add_played_card(self.card_data.id)
	make_unclicable()
	emit_signal("card_played")
	emit_signal("close_requested")

func get_used_tips_count() -> int :
	var used_tips := 0
	for tip in tips.get_children() :
		if tip.used :
			used_tips += 1
	return used_tips
