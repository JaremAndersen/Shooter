extends CharacterBody2D

signal player_shoot_laser(pos, direction)
signal player_shoot_grenade(pos, direction)

var can_laser: bool = true
var can_grenade: bool = true

@export var max_speed: int = 500
var speed: int = max_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		
		$GPUParticles2D.emitting = true
		player_shoot_laser.emit(selected_laser.global_position, player_direction)
		can_laser = false
		$LaserTimer.start()
		
	if Input.is_action_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		
		player_shoot_grenade.emit(selected_laser.global_position, player_direction)
		can_grenade = false
		$GrenadeTimer.start()


func _on_laser_timer_timeout():
	can_laser = true 

func _on_grenade_timer_timeout():
	can_grenade = true
	
func hit():
	Globals.player_health -= 10
	

