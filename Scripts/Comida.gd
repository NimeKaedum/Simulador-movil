extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var nearObjects

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

#func _on_area_2d_body_entered(body):
	#if body.scene_file_path == "res://Escenas/Pez_Vida.tscn":
		#if body.fish_hungry == true:
			#body.hambre = 60
			#body.fish_founded = false
			#body.fish_searching = false
			#body.dir = Vector2.ZERO
			#body.velocity = Vector2.ZERO
			#queue_free()

func _on_refresh_timeout():
	nearObjects = $Area2D.get_overlapping_bodies()
	for nearObjects in nearObjects:
		if nearObjects.scene_file_path == "res://Escenas/Pez_Vida.tscn":
			if nearObjects.fish_hungry == true:
				nearObjects.hambre = 45
				nearObjects.fish_founded = false
				nearObjects.fish_searching = false
				nearObjects.dir = Vector2.ZERO
				nearObjects.velocity = Vector2.ZERO
				queue_free()
				break
		elif nearObjects.scene_file_path == "res://Escenas/Pez_Chiquito.tscn":
			if nearObjects.fish_hungry == true:
				nearObjects.hambre = 20
				nearObjects.fish_founded = false
				nearObjects.fish_searching = false
				nearObjects.dir = Vector2.ZERO
				nearObjects.velocity = Vector2.ZERO
				queue_free()
				break


