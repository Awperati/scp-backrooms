## Projectile fired by Watcher entity.
extends Area3D

var speed: float = 10.0
var damage: float = 10.0
var target: Node3D
var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Set collision shape
	var shape = SphereShape3D.new()
	shape.radius = 0.2
	$Collision.shape = shape
	
	# Set direction toward target
	if target:
		direction = (target.global_position - global_position).normalized()

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
	# Remove after 5 seconds
	if is_inside_tree():
		var age = get_tree().get_time() - _spawn_time
		if age > 5.0:
			queue_free()

var _spawn_time: float = 0.0

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		GameController.lose_sanity(damage)
		queue_free()
