extends Area3D

@export var damage := 1

signal body_part_hit(dam)


#called when node enters the scene tree for the first time
func _ready():
	pass
func _process(delta):
	pass
	
func hit():
	emit_signal("body_part_hit",damage)
