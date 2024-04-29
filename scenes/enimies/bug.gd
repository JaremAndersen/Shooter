extends CharacterBody2D


const SPEED = 300.0
var player_nearby: bool = false
var player_in_attack_range: bool = false
var player
var attack_on_cooldown: bool = false
var health = 50
var invulnerable: bool = false

func _process(_delta):
	if player_nearby and not player_in_attack_range:
		$AnimatedSprite2D.play("walk")
		look_at(Globals.player_pos)
		velocity = (Globals.player_pos - global_position).normalized() * SPEED
		move_and_slide()
		
	if player_in_attack_range:
		if not attack_on_cooldown:
			attack_on_cooldown = true
			$AnimatedSprite2D.play("attack")
			$AttackCooldown.start()
		#look_at(Globals.player_pos)
		#velocity = (Globals.player_pos - global_position).normalized() * SPEED
		#move_and_slide()
	

func _on_notice_area_body_entered(body):
	player_nearby = true
	player = body

func _on_attack_area_body_entered(_body):
	player_in_attack_range = true
	


func _on_attack_area_body_exited(_body):
	player_in_attack_range = false


func _on_attack_cooldown_timeout():
	attack_on_cooldown = false
	
func hit():
	if not invulnerable:
		health -= 10
		invulnerable = true
		$InvulnerabilityTimer.start()
		$AnimatedSprite2D.material.set_shader_parameter("progress", 0.6)
		$Particles/HitParticles.emitting = true
		if health <= 0:
			await get_tree().create_timer(0.5).timeout
			queue_free()


func _on_invulnerability_timer_timeout():
	invulnerable = false
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)
	


func _on_animated_sprite_2d_animation_finished():
	if player_in_attack_range and "hit" in player :
		player.hit()
