extends RigidBody2D

signal grenade_explode(pos, blas_radius)

const speed = 750
const blast_radius = 400
var explosion_active: bool = false


func explode():
	$AnimationPlayer.play("Explosion")
	explosion_active = true

func _process(_delta) :
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Entity") + get_tree().get_nodes_in_group("Container")
		for target in targets:
			var distance = global_position.distance_to(target.global_position)
			if distance < blast_radius and "hit" in target:
				target.hit()
