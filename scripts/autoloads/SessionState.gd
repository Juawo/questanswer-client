extends Node

var cards_from_database: Array[CardData]
var num_cards : int

func populate_card_datas(cards_data: Array):
	cards_from_database.clear()
	for card in cards_data:
		cards_from_database.append(card)
	if(len(cards_from_database) == 0):
		num_cards = len(SaveManager.played_cards_ids)
	else :
		num_cards = len(cards_from_database) + len(SaveManager.played_cards_ids)
	
