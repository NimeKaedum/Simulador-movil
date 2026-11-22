extends Sprite2D

var velocity = Vector2()
var speed = 100

func _ready():
	randomize()
	set_process(true)

func _process(delta):
	#Generar un adirección aleatoria para el movimietno 
	var random_direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	velocity = random_direction * speed * delta
	position += velocity
	
	#Mantener el pez dentro de los límites de la pantalla
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
