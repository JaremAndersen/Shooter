extends CharacterBody2D

var active: bool = false
var speed: int = 400
var speed_multiplier: int = 1
var max_speed: int = 2000
var invulnerable: bool = false
var health: int = 50

func _ready():
	$Explosion.hide()
	$Sprite2D.show()

func _process(delta):
	
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - global_position).normalized()
		velocity = direction * speed * speed_multiplier
		var collision = move_and_collide(velocity * delta)
		if collision:
			var targets = get_tree().get_nodes_in_group("Entity") + get_tree().get_nodes_in_group("Container")
			for target in targets:
				var distance = global_position.distance_to(target.global_position)
				if distance < 400 and "hit" in target:
					target.hit()
			$AnimationPlayer.play("Explosion")

func hit():
	if not invulnerable:
		health -= 10
		invulnerable = true
		$InvulnerabilityTimer.start()
		$Sprite2D.material.set_shader_parameter("progress", 0.6)
	if health <= 0:
		speed = 0
		$AnimationPlayer.play("Explosion")


func _on_notice_area_body_entered(_body):
	active = true
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 6)

func stop_movement():
	speed_multiplier = 0

func _on_invulnerability_timer_timeout():
	invulnerable = false
	$Sprite2D.material.set_shader_parameter("progress", 0)
	
