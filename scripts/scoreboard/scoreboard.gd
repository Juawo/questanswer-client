extends Control

@onready var players_rank: VBoxContainer = $NinePatchRect/MarginContainer/VBoxContainer/players_rank
const RANK_ELEMENT = preload("uid://cqnmttyneesyj")

var scores : Dictionary
@onready var comment: Label = $NinePatchRect/MarginContainer/VBoxContainer/comment

@onready var players_rank_wrapper: Control = $NinePatchRect/MarginContainer/VBoxContainer/players_rank_wrapper

@export var LINE_HEIGHT := 65.0 # rank_elemnt size:y
@export var MARGIN := 16 # maargin beteween rank_elements
var size_x_element 

func _ready() -> void:	
	size_x_element = $NinePatchRect/MarginContainer/VBoxContainer/players_rank_wrapper.size.x

func populate_scoreboard() -> void :
	_ordering_scores()
	
	for child in players_rank.get_children():
		child.queue_free()
	
	for i in range(scores.size()) :
		var p_name = scores.keys()[i]
		var element = RANK_ELEMENT.instantiate()
		players_rank_wrapper.add_child(element)
		element.populate_rank_element(p_name, scores[p_name])
		if size_x_element == 0.0 :
			size_x_element = 272
		
		element.custom_minimum_size.x = size_x_element
		element.size.x = size_x_element
		print("players_rank_wrapper.size.x : ", players_rank_wrapper.size.x)
		element.size.y = LINE_HEIGHT
		element.position.y = i * (LINE_HEIGHT + MARGIN)
		element.position.x = 0.0
	_update_rank_positions_only()
	
func sort_animate_scoreboard() -> void :
	# update the data and sort
	_ordering_scores()
	# update the points of the ui
	update_scoreboard_points()
	# sort the ui
	ordering_rank_elements()
	players_rank.queue_sort()
	await get_tree().process_frame
	update_comment()

func update_scoreboard_points() -> void :
	for p_name in scores.keys() :
		for child in players_rank_wrapper.get_children() :
			if child.player_name == p_name:
				if child.has_method("animate_score_counter"):
					child.animate_score_counter(scores[p_name], 0.4)
				else:
					child.update_player_score(scores[p_name])

func ordering_rank_elements() -> void :
	var ranks = players_rank_wrapper.get_children()
	
	var tween = create_tween().set_parallel(true)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_ease(Tween.EASE_OUT)
	
	var scores_keys = scores.keys()
	
	for i in range(scores_keys.size()) :
		for j in range(ranks.size()):
			if scores_keys[i] == ranks[j].player_name:
				var target_position = i * (LINE_HEIGHT + MARGIN)
				var target_element = ranks[j]
				tween.tween_property(target_element, "position:y", target_position, 0.5)
				
				if ranks[j].has_method("animate_rank_change"):
					ranks[j].animate_rank_change(i + 1)

func _ordering_scores() -> void :
	scores = SessionState.scores
	var keys = scores.keys()
	keys.sort_custom(func(a,b): return scores[a] > scores[b])
	
	var sorted_dict : Dictionary = {}
	for key in  keys :
		sorted_dict[key] = scores[key]
	scores = sorted_dict
	print(scores)

func _update_rank_positions_only() -> void:
	var elements = players_rank_wrapper.get_children()
	for i in range(elements.size()):
		var real_position = i + 1
		if "rank_position" in elements[i]:
			elements[i].rank_position = real_position

func update_comment() -> void :
	var names = scores.keys()
	if scores[names[0]] != 0 :
		comment.text = names[0] + " está a " + str(SessionState.max_points_to_win - scores[names[0]]) +"pts "+ "pontos de vencer"
	else : 
		comment.text = "O primeiro com " + str(SessionState.max_points_to_win) + "pts" + "vence a rodada!"

func toggle_show_scoreboard(is_showing : bool) -> void :
	visible = is_showing
