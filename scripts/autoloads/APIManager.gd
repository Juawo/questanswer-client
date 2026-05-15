extends Node

signal cards_fetched_sucessfully(cards_data: Array)
signal request_failed(error_message: String)

var API_BASE_URL : String = "https://madalyn-thoroughgoing-continuedly.ngrok-free.dev" # URL do Render

func _ready() -> void:
	_load_configs()
	SaveManager.finished_load_data.connect(fetch_unplayed_cards)

func _load_configs() -> void:
	var config = ConfigFile.new()
	var err = config.load("res://configs/secret_configs.cfg")
	if err == OK:
		API_BASE_URL = config.get_value("network", "api_url", API_BASE_URL)
		print("Configurações de rede carregadas.")
	else:
		print("Usando configurações padrão (Desenvolvimento).")

# Função genérica para criar requisições (Evita repetição de código)
func _create_request(endpoint: String, method: int, callback: Callable, body: String = ""):
	var request = HTTPRequest.new()
	add_child(request)
	
	# Headers incluindo a segurança que criamos no Render
	var headers = [
		"Content-Type: application/json"
	]
	
	request.request_completed.connect(func(res, code, h, b): 
		callback.call(res, code, h, b)
		request.queue_free() # Auto-limpeza
	)
	
	var url = API_BASE_URL + endpoint
	print("Req para : ", url)
	request.request(url, headers, method, body)

func fetch_unplayed_cards():
	var played_ids : Array = SaveManager.played_cards_ids
	var endpoint = "/api/Card"
	
	if not played_ids.is_empty():
		var ids_string = ",".join(played_ids.map(func(id): return str(int(id))))
		endpoint += "?exclude=" + ids_string
	
	_create_request(endpoint, HTTPClient.METHOD_GET, _on_cards_received)

func _on_cards_received(result, response_code, headers, body):
	if response_code != 200:
		request_failed.emit("Erro ao buscar cartas: %d" % response_code)
		return
	print("Chegou!")
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json is Array:
		var cards_data = []
		for card_dict in json:
			cards_data.append(CardData.new(card_dict))
		
		SessionState.populate_card_datas(cards_data)
		cards_fetched_sucessfully.emit(cards_data)
	else:
		request_failed.emit("Formato de JSON inválido.")
