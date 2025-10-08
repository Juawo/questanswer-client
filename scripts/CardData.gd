class_name CardData
extends RefCounted

var id: int
var term: String
var category: String
var tips: Array[String]

func _init(data: Dictionary) -> void:
	self.id = data.get("id", -1)
	self.term = data.get("term", "Erro : Sem Termo")
	self.category = data.get("category", "Erro : Sem Categoria")
	var recived_tips = data.get("tips", [])
	if recived_tips is Array:
		for tip in recived_tips:
			self.tips.append(tip)
