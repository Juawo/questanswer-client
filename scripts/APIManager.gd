extends Node

var http_request_node : HTTPRequest = HTTPRequest.new()
var header = ["Content-Type: application/json"]
func _ready() -> void:
	add_child(http_request_node)
	http_request_node.request_completed.connect(self._on_request_completed)

func request_all_cards():
		http_request_node.request("http://localhost:5161/api/Card/",
		header, HTTPClient.METHOD_GET)


func _on_request_completed(result, response_code, headers, body):
	var json_result = JSON.parse_string(body.get_string_from_utf8())
	
	if not json_result:
		print("Erro: Nao foi possivel decodificar o JSON.")
		print("Resposta do servidor: ", body.get_string_from_utf8())
		return
	var data = json_result
	
	print("Dados recebidos: ", data)
	
