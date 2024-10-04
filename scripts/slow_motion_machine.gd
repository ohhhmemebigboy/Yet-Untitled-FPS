extends Node

var slowmo_on = false
var slowmoMeter = 200

@export var normal_time_scale : float = 1.0
@export var slowmo_time_scale : float = 0.5

func _physics_process(delta):
	if Input.is_action_just_pressed("slowmo"):
		if slowmo_on == false:
			slowmo_on = true
		elif slowmo_on == true:
			Engine.time_scale = normal_time_scale
			slowmo_on = false

func _process(delta):
	if slowmo_on == true:
		while Engine.time_scale > slowmo_time_scale:
				Engine.time_scale -= .01
	if slowmo_on == false:
		while Engine.time_scale < slowmo_time_scale:
				Engine.time_scale += .01
	#Increases and decreases meter when it's on
	if slowmo_on == true and slowmoMeter > 0:
		slowmoMeter -= 1
	if slowmo_on == false and slowmoMeter < 200:
		slowmoMeter += 1
	
	#Ensures the meter never goes over cap or under 0
	if slowmoMeter > 200:
		slowmoMeter = 200
	if slowmoMeter <= 0:
		slowmoMeter = 0
		Engine.time_scale = normal_time_scale
		slowmo_on = false
	#print(str(slowmoMeter))
