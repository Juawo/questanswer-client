class_name CardData
extends RefCounted

var id: int
var term: String
var category: String
var hints: Array[String]

func _init(data: Dictionary) -> void:
	self.id = data.get("id", -1)
	self.term = data.get("term", "Erro : Sem Termo")
	self.category = data.get("category", "Erro : Sem Categoria")
	self.hints = data.get("hints", [])
