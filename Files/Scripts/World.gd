extends Node3D

@onready var main_menu = $"CanvasLayer/Main Menu"
@onready var address = $"CanvasLayer/Main Menu/MarginContainer/VBoxContainer/AddressEntry"

const PORT = 9999
const Player = preload("res://Files/Scenes/player.tscn")
var enet_peer = ENetMultiplayerPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _on_join_button_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_address_entry_text_submitted(new_text):
	pass # Replace with function body.


func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
