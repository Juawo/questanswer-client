extends Node

signal player_win(player_name : String)
signal new_guesser_time(guesser_name : String)

var cards_from_database: Array[CardData]
var num_cards : int
var num_tips_in_a_card : int = 10

var players : Array[String] = []
var scores : Dictionary = {} 
var order_of_players : Array = []

var questioner_idx : int
var guesser_idx : int
var used_tips_count : int

var max_points_to_win :int = 20

func setup(players_names : Array[String]) -> bool :
	players.clear()
	scores.clear()
	
	# receive player's name
	if !receive_players_names(players_names) :
		printerr("Players name have an erro, try again!")
		return false
	
	# get players name for order
	order_of_players = players.duplicate()
	
	# Reset players score
	for player in  order_of_players :
		scores[player] = 0
		
	# Shuffle players order
	order_of_players.shuffle()
	
	# Reset questioner and guesser
	questioner_idx = 0
	guesser_idx = 1
	used_tips_count = 0
	return true
	
func receive_players_names(players_name : Array[String]) -> bool :
	players.clear()
	if players_name.is_empty() :
		printerr("The game can't be initialized whitout players!")
		return false
		
	for player in players_name :
		if player.is_empty():
			printerr("A player can't have a empty name!")
			return false
		players.append(player)

	return true

func get_questioner_name() -> String :
	return order_of_players[questioner_idx]

func get_guessers_sequence_name() -> Array[String] :
	var sequence : Array[String]
	for i in range(order_of_players.size()) :
		if i != questioner_idx:
			sequence.append(order_of_players[i])
	return sequence

func get_guesser_name() -> String :
	return order_of_players[guesser_idx]

func _on_player_hit() -> void :
	# get players's name that have hit the term and the questioner
	var guesser_name = order_of_players[guesser_idx]
	var questioner_name = order_of_players[questioner_idx]
	
	# calculate the points
	var guesser_points = (num_tips_in_a_card + 1) - used_tips_count
	var questioner_points = used_tips_count
	
	# add points for the player's score
	scores[guesser_name] += guesser_points
	scores[questioner_name] += questioner_points
	
	# reset number of tips used
	used_tips_count = 0
	
	# The player that have hit the term will become the questioner now
	questioner_idx = guesser_idx
	
	# Check if anybody have win the round
	if check_victory_condition() :
		return

	# Is the next player time to guess
	next_guesser_time()

func _on_player_miss() -> void :
	if used_tips_count >= num_tips_in_a_card:
		_on_all_player_missed()
		return
	next_guesser_time()

func _on_all_player_missed() -> void :
	var questioner_name = order_of_players[questioner_idx]
	var questioner_points = used_tips_count
	scores[questioner_name] += questioner_points
	
	used_tips_count = 0
	
	if check_victory_condition():
		return
	
	questioner_idx = (questioner_idx + 1) % order_of_players.size()
	guesser_idx = (questioner_idx + 1) % order_of_players.size()

func next_guesser_time() -> void :
	guesser_idx = (guesser_idx + 1) % order_of_players.size()
	if guesser_idx == questioner_idx :
		next_guesser_time()
	new_guesser_time.emit(order_of_players[guesser_idx])

func _on_tip_used() -> void :
	used_tips_count += 1

func check_victory_condition() -> bool :
	for player in scores :
		if scores[player] >= max_points_to_win :
			player_win.emit(player)
			return true
	return false

func populate_card_datas(cards_data: Array):
	cards_from_database.clear()
	for card in cards_data:
		cards_from_database.append(card)
	if(len(cards_from_database) == 0):
		num_cards = len(SaveManager.played_cards_ids)
	else :
		num_cards = len(cards_from_database) + len(SaveManager.played_cards_ids)
