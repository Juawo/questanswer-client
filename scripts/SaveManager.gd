extends Node

var file_path: String = "user://questanswer_data.json"
var played_cards_ids: Array[int]

func _ready() -> void:
	load_data()

func add_played_card(card_id: int):
	if not played_cards_ids.has(card_id):
		self.played_cards_ids.append(card_id)
		save_data()
	else:
		print("Essa carta ja foi jogada")

func save_data():
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	if not save_file:
		print("Nao foi possivel abrir o arquivo para escrita")
		return
	var json_data = JSON.stringify(played_cards_ids)
	save_file.store_line(json_data)
	save_file.close()

func load_data():
	if not FileAccess.file_exists(file_path):
		print("O arquivo de dados persistente nao existe")
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	if not save_file:
		print("Nao foi possivel abrir o arquivo para leitura")
		return
	
	var json_data = save_file.get_as_text()
	save_file.close()
	
	var loaded_data = JSON.parse_string(json_data)
	if loaded_data is Array:
		self.played_cards_ids = loaded_data
	else:
		print("Erro, os dados do arquivo persistente nao sao validos")
