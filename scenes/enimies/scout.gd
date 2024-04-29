extends CharacterBody2D

const SPEED = 300.0
var player_nearby: bool = false
var can_laser: bool = true
var last_shot = 0

var health: int = 30
var invulnerable = false

signal laser(pos, direction)

func _process(_delta):
	if player_nearby: 
		look_at(Globals.player_pos)
		velocity = (Globals.player_pos - global_position).normalized() * SPEED
		move_and_slide()
		
		if can_laser:
			var pos: Vector2 = $LaserSpawnPositions.get_child(last_shot % $LaserSpawnPositions.get_child_count()).global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			last_shot += 1
			$Timers/LaserCooldown.start()



func _on_attack_area_body_entered(_body):
	player_nearby = true

func _on_attack_area_body_exited(_body):
	player_nearby = false

func _on_laser_cooldown_timeout():
	can_laser = true
	
func hit():
	if not invulnerable:
		health -= 10
		invulnerable = true
		$Timers/InvulnerabilityTimer.start()
		$Sprite2D.material.set_shader_parameter("progress", 1)
		if health <= 0:
			queue_free()


func _on_invulnerability_timer_timeout():
	invulnerable = false
	$Sprite2D.material.set_shader_parameter("progress", 0)
	
