extends CharacterBody2D
class_name Pez_Flow

@onready var movement: Movement = $"Movement" as Movement
@onready var sensor: Area2D = $"Sensor"

var player: CollisionObject2D

func _ready():
	movement.setupt(self)

func _on_sensor_boy_entered(body):
	player = body
