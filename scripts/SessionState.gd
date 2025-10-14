extends Node

var cards_from_database: Array[CardData]

func populate_card_datas(cards_data: Array):
	cards_from_database.clear()
	for card in cards_data:
		cards_from_database.append(card)
