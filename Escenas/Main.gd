extends Node2D

var verde = preload("res://Escenas/Pez_Vida.tscn")
var rosa = preload("res://Escenas/Pez_Chiquito.tscn")
var azul = preload("res://Escenas/pez_enemy.tscn")
var rojo = preload("res://Escenas/pez_CARNIVORO.tscn")

var larga = preload("res://Escenas/Alga_Larga.tscn")
var gorda = preload("res://Escenas/Alga_Frondosa.tscn")
var canon = preload("res://Escenas/alga.tscn")
var fake = preload("res://Escenas/Alga_recta.tscn")

var inv
var instance_pez
var prueba = "XD"

func _physics_process(delta):
	if Input.is_action_just_pressed("click"):
		inst(get_global_mouse_position())

func inst(pos):
	inv = get_tree().get_root().get_node("Node2D/Control")

	if inv.is_visible():
		if pos.x > -574 && pos.x < 569 && pos.y > -649 && pos.y < -106:
			pass
		else:
			instanciar(pos)
	elif pos.x > -139 && pos.x < 134 && pos.y > -631 && pos.y < -544:
		pass
	else:
		instanciar(pos)


func instanciar(pos):
	match prueba:
		"XD":
			return
		"Verde":
			instance_pez = verde.instantiate()
		"Rosa":
			instance_pez = rosa.instantiate()
		"Rojo":
			instance_pez = rojo.instantiate()
		"Azul":
			instance_pez = azul.instantiate()
		"Larga":
			instance_pez = larga.instantiate()
		"Gorda":
			instance_pez = gorda.instantiate()
		"Canon":
			instance_pez = canon.instantiate()
		"Fake":
			instance_pez = fake.instantiate()
	
	instance_pez.position = pos
	add_child(instance_pez)

func _on_inicio_pressed():
	inv = get_tree().get_root().get_node("Node2D/Control")
	inv.show()
