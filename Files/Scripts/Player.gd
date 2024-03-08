extends CharacterBody3D

var killcount = 0
var instance
var speed
var health = 100
const WALKSPEED = 5.0
const SPRINTSPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = .008
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_anim = $Head/Camera3D/gun/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/gun/RayCast3D

#Bullets
var bullet = load("res://scenes/bullet.tscn")
var killcountertag
#fov variables
const BASE_FOV = 90
const FOV_CHANGE = 1.5
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-48), deg_to_rad(60))
func _physics_process(delta):
	$Head/Camera3D/kills.text = "Kill Counter: " + var_to_str(killcount)
	killcountertag = $Head/Camera3D/kills.text
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Handle Sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINTSPEED
	else:
		speed = WALKSPEED
		
	#exit game
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x,direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x,direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINTSPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	


	
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
	
	move_and_slide()

func hurt(hit_points):
	if hit_points > 0:
		health -= hit_points
		$Head/Camera3D/ProgressBar.value = health
	else:
		health = 0
	if health == 0:
		die()
func die():
	get_tree().change_scene_to_file("res://scenes/menu_2.tscn")
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func incrementKills():
	killcount+=1

