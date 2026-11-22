extends CharacterBody2D

const speed = 30 #Velocidad base
var dir: Vector2 #Vector de direccion random
var room: Vector2 #Vector de direccion hacia objeto
var is_fish_chase: bool #Estado de pez en persecusion
var fish_searching: bool
var fish_founded: bool
var fish_hungry: bool #Estado de pez hambriento
var segs_time: bool #Estado de pez buscando reproducirse
var player: CharacterBody2D #No c
var objective = null #Variable para almacenar objeto de comida, para obtener su ubicacion
var life_time = 100 #Tiempo de vida del pez en segundos
var hambre = 40 #Segundos que sobrevive sin comida el pez
var newf = load("res://Escenas/Pez_Vida.tscn")
var parent
var nearObjects
var nearestsearch

#Se inicializan los estados
func _ready():
	parent = get_tree().get_root().get_node("Node2D")
	fish_searching = false
	fish_founded = false
	segs_time = false
	is_fish_chase = false
	fish_hungry = false

#Se llaman las funciones de vida del pez
func _process(delta):
	move(delta) #Toda la funcion de movimiento
	update_life(delta) #Funcion de vida
	update_hambre(delta) #Funcion de hambre
	handle_animation() #Funcion de animaciones

#Funcion de movimiento
func move(delta):
	if fish_searching == true:
		room = (objective.global_position - global_position).normalized() #Obtener ubicacion del objetivo
		#$Timer.paused
		if fish_founded == true:
			velocity = room * delta * speed * 400 #Movimiento cuando el pez encontro al objetivo
			#velocity += ((dir * speed) - velocity) * delta * 5
		else:
			velocity += ((room + dir) / 2) * delta * speed * 2#Movimiento cuando el pez esta buscando comida o pareja
			#velocity += ((dir * speed) - velocity) * delta * 10
	elif !is_fish_chase:
		velocity += dir * speed * delta #Movimiento cuando el pez esta en idle
	move_and_slide()

#Timer de movimiento random, selecciona vectores al azar todo el rato
func _on_timer_timeout():
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !is_fish_chase && fish_founded == false: #Solo se asignan los vectores random cuando no tiene un objetivo
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])

func _on_segs_timeout():
	segs_time = true

#Funcion para animaciones
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("Nadar")
	if dir.x == -1:
		animated_sprite.flip_h = true
	elif dir.x == 1:
		animated_sprite.flip_h = false #El sprite gira dependiendo de la velocidad aplicada
	if fish_hungry == true && fish_founded == false:
		$Hambre.play("1") #Animacion cuando el pez esta hamriento
	elif fish_founded == true:
		$Hambre.play("2") #Animacion cuando el pez encontro comida
	elif segs_time == true:
		$Hambre.play("3") #Animacion cuando el pez encontro pareja
	elif fish_hungry == false && fish_founded == false && segs_time == false:
		$Hambre.seek(0, true) #Reinicio a animacion idle
		$Hambre.stop()

#Funcion para randomizar array
func choose(array):
	array.shuffle()
	return array.front()

#Funcion que gestiona la vida restante del pez
func update_life(delta):
	# Reducir el tiempo de vida
	life_time -= delta
	if life_time <= 0:
		queue_free()  # Eliminar el pez cuando su tiempo de vida se acaba

#Funcion que gestiona el hambre del pez
func update_hambre(delta):
	hambre -= delta
	if hambre > 25: 
		fish_hungry = false #Cuando quedan 25 segundos, se actualiza el estado del pez para que busque comida
	elif hambre <= 25:
		fish_hungry = true #Se quita el hambre cuando se tienen mas de 25 segundos
		if hambre <= 0:
			queue_free() #El pez muere con 0 de hambre

func _on_refresh_timeout():
	nearObjects = $Search.get_overlapping_bodies()
	nearestsearch = get_tree().get_root().get_node("Node2D/Comparador")

	if fish_hungry == true:
		for nearObjects in nearObjects:
			if nearObjects.scene_file_path == "res://Escenas/Comida.tscn":
				if nearObjects.global_position.distance_to(global_position) < nearestsearch.global_position.distance_to(global_position):
					nearestsearch = nearObjects
					objective = nearObjects
					fish_searching = true
	elif segs_time == true:
		for nearObjects in nearObjects:
			if nearObjects.scene_file_path == "res://Escenas/Pez_Vida.tscn":
				if nearObjects.global_position.distance_to(global_position) < nearestsearch.global_position.distance_to(global_position) && nearObjects != self:
					if nearObjects.segs_time == true:
						nearestsearch = nearObjects
						objective = nearObjects
						fish_searching = true
	
	nearObjects = $Found.get_overlapping_bodies()
	nearestsearch = get_tree().get_root().get_node("Node2D/Comparador")
	
	if fish_hungry == true:
		for nearObjects in nearObjects:
			if nearObjects.scene_file_path == "res://Escenas/Comida.tscn":
				fish_founded = true #Actualiza el estado, el pez ha encontrado comida
	elif segs_time == true:
		for nearObjects in nearObjects:
			if nearObjects.scene_file_path == "res://Escenas/Pez_Vida.tscn" && nearObjects != self:
				if nearObjects.segs_time == true:
					fish_founded = true #Actualiza el estado, el pez ha encontrado comida
	
	#nearObjects = $Segsarea.get_overlapping_bodies()
	#for nearObjects in nearObjects:
		#if nearObjects.scene_file_path == "res://Escenas/Pez_Vida.tscn": #Verifica que es un pez de la amisma especie
			#if segs_time == true && nearObjects.segs_time == true:
				#print("SEGS")
				#fish_searching = false
				#fish_founded = false
				#segs_time = false
				#room = Vector2.ZERO
				#velocity = Vector2.ZERO
				#
				#nearObjects.fish_founded = false
				#nearObjects.segs_time = false
				#nearObjects.fish_searching = false
				#nearObjects.room = Vector2.ZERO
				#nearObjects.velocity = Vector2.ZERO
				#
				#var create_fish = newf.instantiate()
				#create_fish.position = get_position_delta()
				#parent.add_child(create_fish)
				#
				#break
			#
		#if nearObjects.scene_file_path == "res://Escenas/Pez_enemy.tscn":
			#if nearObjects.fish_hungry == true:
				#nearObjects.hambre = 100
				#nearObjects.fish_founded = false
				#nearObjects.fish_searching = false
				#nearObjects.dir = Vector2.ZERO
				#nearObjects.velocity = Vector2.ZERO
				#queue_free()
				#break
	
##Objetos entrantes al area grande
#func _on_area_2d_body_entered(body):
	#if fish_hungry == true && fish_searching == false: #Se verifica que tiene hambre y no tiene un objetivo
		#if body.scene_file_path == "res://Escenas/Comida.tscn": #Verifica que es una semilla
			#objective = body #Establece objetivo para funciones de movimiento
			#fish_searching = true #Actualiza estado
			#print("Found food") #Comprobacion en consola
	#elif segs_time == true && fish_searching == false:
		#if body.scene_file_path == "res://Escenas/Pez_Vida.tscn": #Verifica que es un pez de la amisma especie
			#if body.segs_time == true: #Verifica que el otro pez no esta en coldown de segs
				#objective = body #Establece objetivo para funciones de movimiento
				#fish_searching = true #Actualiza estado
				#print("Found fish") #Comprobacion en consola
#
#Objetos salientes del area grande, solo para comida, por si el objetivo es eliminado por alguna razon
func _on_area_2d_body_exited(body):
	if fish_searching == true: #↓
		if body == objective: #verifica que el objeto saliente sea el objetivo del pez
			room = Vector2.ZERO #Quita direccion de movimiento
			fish_searching = false #Revierte estado para que vuelva a buscar
#
##Objetos entrantes en el area chica, comida, peces de la misma especie y enemigos
#func _on_area_2d_2_body_entered(body):
	#if fish_searching == true && fish_found_food == false && fish_hungry == true: #Verifica el estado del pez, si tiene hambre
		#if body.scene_file_path == "res://Escenas/Comida.tscn": #Verifica que sea comida
			#fish_found_food = true #Actualiza el estado, el pez ha encontrado comida
			#objective = body #actualiza si es necesario el objetivo de movimiento
			#print("Comida time") #Comprobacion en consola
	#elif fish_searching == true && segs_founded == false && segs_time == true: #Verifica el estado del pez, si tiene hambre
		#if body.scene_file_path == "res://Escenas/Pez_Vida.tscn": #Verifica que es un pez de la amisma especie
			#if body.segs_time == true: #Verifica que el otro pez no esta en coldown de segs
				#segs_founded = true #Actualiza el estado, el pez ha encontrado pareja
				#objective = body #actualiza si es necesario el objetivo de movimiento
				#print("Segs time") #Comprobacion en consola
#
#Objetos salientes del area chica, si son eliminados por cualquier razon
func _on_area_2d_2_body_exited(body):
	if fish_founded == true: #↓
		if body == objective: #verifica que el objeto saliente sea el objetivo del pez
			room = Vector2.ZERO #Quita direccion de movimiento
			fish_founded = false #Revierte estado para que vuelva a buscar

#Peces que entran en area de segs para reproducirse
func _on_segsarea_body_entered(body):
	if body.scene_file_path == "res://Escenas/Pez_Vida.tscn": #Verifica que es un pez de la amisma especie
		if segs_time == true && body.segs_time == true:
			fish_searching = false
			fish_founded = false
			segs_time = false
			room = Vector2.ZERO
			velocity = Vector2.ZERO
			
			body.fish_founded = false
			body.segs_time = false
			body.fish_searching = false
			body.room = Vector2.ZERO
			body.velocity = Vector2.ZERO
			
			var create_fish = newf.instantiate()
			create_fish.position = get_position_delta()
			parent.add_child(create_fish)
			
	if body.scene_file_path == "res://Escenas/pez_enemy.tscn":
		if body.fish_hungry == true:
			body.hambre = 60
			body.fish_founded = false
			body.fish_searching = false
			body.dir = Vector2.ZERO
			body.velocity = Vector2.ZERO
			queue_free()
	if body.scene_file_path == "res://Escenas/pez_CARNIVORO.tscn":
		if body.fish_hungry == true:
			body.hambre = 80
			body.fish_founded = false
			body.fish_searching = false
			body.dir = Vector2.ZERO
			body.velocity = Vector2.ZERO
			queue_free()

