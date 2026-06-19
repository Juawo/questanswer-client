extends Node

signal finished_load_data

var file_path: String = "user://questanswer_data.json"
var played_cards_ids: Array

# config
var music_volume : float
var sfx_volume : float

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
	var json_data = played_cards_ids
	var data = {
		"settings" : {
			"music_volume" : music_volume,
			"sfx_volume" : sfx_volume
		},
		"played_ids" : json_data
	}
	save_file.store_line(JSON.stringify(data))
	save_file.close()

func load_data():
	if not FileAccess.file_exists(file_path):
		print("O arquivo de dados persistente nao existe")
		return # Adicionado para evitar ler um arquivo que não existe

	var save_file = FileAccess.open(file_path, FileAccess.READ)
	if not save_file:
		print("Nao foi possivel abrir o arquivo para leitura")
		return
	
	var json_data = JSON.parse_string(save_file.get_as_text())
	save_file.close()

	# Garante que os dados decodificados são um Dicionário válido
	if json_data is Dictionary:
		played_cards_ids = json_data.get("played_ids", [])
		
		# Como music e sfx estão dentro do dicionário "settings", acessamos assim:
		var settings = json_data.get("settings", {})
		if settings is Dictionary:
			music_volume = settings.get("music_volume", 100.0)
			sfx_volume = settings.get("sfx_volume", 100.0)
	else:
		print("Erro: Os dados lidos não estão no formato esperado (Dicionário).")
		save_data() 
		
	finished_load_data.emit()
