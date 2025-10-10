extends Control

var card_scene: PackedScene = preload("res://scenes/card.tscn")

func _ready() -> void:
	var instance = card_scene.instantiate()
	print("intance : ", instance)
