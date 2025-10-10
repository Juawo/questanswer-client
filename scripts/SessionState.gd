extends Node

var cards_from_database: Array[CardData]

func populate_card_datas(cards_data: Array):
	cards_from_database.clear()
	for card in cards_data:
		cards_from_database.append(card)

#func get_card_by_id(id_to_find: int) -> CardData:
	#for card in cards_from_database:
		#if card.id == id_to_find:
			#return card
	#return null
