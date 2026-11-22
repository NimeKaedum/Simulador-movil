extends Camera2D

@export var object_to_follow:Node2D

func _process(delta):
	position = object_to_follow.position
