extends Node

signal cards_fetched_sucessfully

var http_request_node : HTTPRequest
const API_BASE_URL : String = "http://localhost:5161/api/Card/"

func _ready() -> void:
	http_request_node = HTTPRequest.new()
	add_child(http_request_node)
	http_request_node.request_completed.connect(self._on_request_completed)
	print("http_request criado")
	fetch_unplayed_cards()

func fetch_unplayed_cards():
	var played_ids : Array = SaveManager.played_cards_ids
	var url = API_BASE_URL
	var headers = ["Content-Type: application/json"]
	
	if not played_ids.is_empty():
		var ids_string = ",".join(played_ids.map(func(id): return str(id)))
		url += "?exlcude" + ids_string
	http_request_node.request(url, headers, HTTPClient.METHOD_GET)
	print("Requisicao feita para %s" %url)

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		printerr("Erro na requisicao! Codigo: %d" % response_code)
		return
	print("Responde Code : %d" % response_code)
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if not json:
		print("Json recebido com erro!")
		return
	if json is not Array:
		print("Json recebido com erro, nao e um Array")
	
	print("Cartas nao jogadas recebidas")
	var cards_data : Array
	for card_dict in json:
		var new_card = CardData.new(card_dict)
		cards_data.append(new_card)
	
	SessionState.populate_card_datas(cards_data)
	emit_signal("cards_fetched_sucessfully")
	print("Cartas adicionadas ao SessionState")
