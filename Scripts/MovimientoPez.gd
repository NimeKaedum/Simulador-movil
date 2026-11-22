extends CharacterBody2D

var eating = false
var walking = false

var xdir = 1 # 1 == right -1 left
var ydir = 1 # 1 == down -1 up
var speed = 5

var motion = Vector2()

var moving_vertical_hortizontal = 1 #1 = hortizontal  2 = vertical


func _ready():
	walking = true
	randomize()
	
func _physics_process(delta):
	var waittime = 1
	if walking == false:
		var x = randf_range(1,2)
		if x > 1.5:
			moving_vertical_hortizontal = 1
		else:
			moving_vertical_hortizontal = 2
			
	if walking == true:
		$AnimatedSprite2D.play("Walking")
		if moving_vertical_hortizontal == 1:
			if xdir == -1:
				$AnimatedSprite2D.flip_h = true
			if xdir == 1:
				$AnimatedSprite2D.flip_h = false
			motion.x = speed * xdir
			motion.y = 0
		elif moving_vertical_hortizontal == 2:
			motion.y = speed * ydir
			motion.x = 0
	if eating == true:
		$AnimatedSprite2D.play("eating")
		motion.x = 0
		motion.y = 0
	
	move_and_slide()

func _on_chances_state_timer_timeout():
	var waittime = 1
	if walking == true:
		eating = true
		walking = false
		waittime = randf_range(1, 5)
	elif eating == true:
		walking = true
		eating = false
		waittime = randf_range(2,6)
	$ChancesStateTimer.wait_time = waittime
	$ChancesStateTimer.start()


func _on_walking_timer_timeout():
	var x = randf_range(1,2)
	var y = randf_range(1,2)
	var waittime = randf_range(1,4)
	
	if x > 1.5:
		xdir = 1 #right
	else:
		xdir = -1 #left
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	$WalkingTimer.wait_time = waittime
	$WalkingTimer.start()
