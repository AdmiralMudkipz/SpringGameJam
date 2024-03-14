extends Area3D


@onready var item = $"."
@onready var mesh = $MeshInstance3D
@onready var coll = $CollisionShape3D

var rand = RandomNumberGenerator.new()
var type = randi_range(1,4)
var cooldown = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _on_body_entered(body):
	
	mesh.visible = false 
	
	await get_tree().create_timer(cooldown).timeout
	mesh.visible = true
	
func spawnPickup():
	var first = randi_range(1,4)
	if first == 1:
		pass
	elif first == 2:
		pass
	elif first == 3:
		pass
	elif first == 4:
		pass
	
