extends Node2D

var COMIDA = preload("res://Escenas/Comida.tscn")
var bandera = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.stop()
	$Timer.wait_time = randf_range(5,15)
	$Timer.start()

func _on_timer_timeout():
	if bandera == false:
		var semilla = COMIDA.instantiate()
		bandera = true
		add_child(semilla)
		semilla.connect("tree_exited", Callable(self, "_on_semilla_exited"))

func _on_semilla_exited():
	bandera = false
	$Timer.start()
