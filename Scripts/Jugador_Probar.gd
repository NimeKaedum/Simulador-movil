extends CharacterBody2D

@export var veloMove = 200

func _ready():
	pass

func _physics_process(delta):
	var direccion = Input.get_vector("Izquierda","derecha","arriba","abajo")
	
	velocity = direccion * veloMove
	move_and_slide()
