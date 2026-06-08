extends Control

@onready var players_vbox: VBoxContainer = $MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/players_vbox
@onready var start_btn: Button = $MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/start_btn
@onready var tip_title: Label = $MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/tip_vbox/tip_title
@onready var tip_text: Label = $MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/tip_vbox/tip_text
var all_input_players : Array[Node]
var players_name : Array[String] = []
const equal_names_detail : String = "Jogador com nome repetido!"

func _ready() -> void:
	all_input_players = players_vbox.get_children()
	for i in range(all_input_players.size()) :
		all_input_players[i].text_changed.connect(_on_any_input_changed)
	
	if !SessionState.players.is_empty() :
		var saved_names_count = min(all_input_players.size(), SessionState.players.size())
		for i in range(saved_names_count) :
			var saved_name = SessionState.players[i]
			if !saved_name.is_empty() :
				all_input_players[i].text = saved_name
				all_input_players[i].line_edit.text = saved_name
	update_inputs_state()

func _on_any_input_changed() -> void :
	update_inputs_state()

func update_inputs_state() -> void :
	var valid_players := 0
	
	if not all_input_players[0].text.is_empty():
		valid_players += 1
	
	for i in range(1, all_input_players.size()) :
		var input_current := all_input_players[i]
		var input_previous := all_input_players[i - 1]
		
		if input_previous.text.is_empty() :
			input_current.is_disabled = true
			input_current.text = ""
			input_current.line_edit.text = ""
		else :
			input_current.is_disabled = false
			
		if not input_current.is_disabled and not input_current.text.is_empty() :
			valid_players += 1
	
	var checked_names = check_players_name()
	start_btn.disabled = (valid_players < 2) or (not checked_names)

func check_players_name() -> bool :
	for i in range(0,all_input_players.size()) :
		var input_current = all_input_players[i]
		
		if input_current.is_disabled or input_current.text.is_empty():
			continue
		
		for j in range(i + 1, all_input_players.size()):
			var other_input = all_input_players[j]
			
			if input_current.is_disabled or input_current.text.is_empty():
				continue
				
			if compare_players_name(input_current.text.strip_edges(), other_input.text.strip_edges()) :
				other_input.update_detail_text(equal_names_detail, Color.ORANGE)
				return false
			else :
				other_input.update_detail_text("", Color.ORANGE)
	return true
	
func compare_players_name(name1 : String, name2 : String) -> bool :
		return (name1 == name2)

func _on_start_btn_pressed() -> void:
	players_name = get_all_players_name()
	var error = !SessionState.setup(players_name)
	if !error :
		await SceneTrasition.fade_in(0.6)
		if SessionState.cards_from_database.is_empty() :
			await ApiManager.cards_fetched_sucessfully
			get_tree().change_scene_to_file("res://scenes/select_card/select_card.tscn")
			await SceneTrasition.fade_out(0.4)
		else :
			await get_tree().create_timer(0.2).timeout
			get_tree().change_scene_to_file("res://scenes/select_card/select_card.tscn")
			await SceneTrasition.fade_out(0.4)
	else :
		_on_erro_to_add_players(error)
	
func _on_erro_to_add_players(have_error : bool) -> void :
	if have_error :
		tip_title.text = "Erro :"
		tip_text.text = "Ocorreu um erro ao \n adicionar os jogadores!"
		tip_text.add_theme_color_override("font_color", Color.ORANGE_RED)

func get_all_players_name() -> Array[String]:
	var inputs : Array[String] = []
	for input in range(all_input_players.size()) :
		if !all_input_players[input].text.is_empty():
			inputs.append(all_input_players[input].text)
	return inputs
