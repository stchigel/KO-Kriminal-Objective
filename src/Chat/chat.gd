extends Panel
@export var nombre: String = "Whatsapp"
@export var sent_bubble_scene: PackedScene
@export var received_bubble_scene: PackedScene
@onready var messages_container = $ScrollContainer/VBoxContainer

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_messages()
	$Label.text = nombre

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	hide()

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset
		


var messages = [
	{"text": "Hello!", "time": "10:32", "sent": false},
	{"text": "Hi there", "time": "10:33", "sent": true},
	{"text": "How are you?", "time": "10:34", "sent": false}
]

func load_messages(mensajes:Array):
	for child in messages_container.get_children():
		child.queue_free()
	for msg in mensajes:
		var bubble: Control
		if msg.sent:
			bubble = sent_bubble_scene.instantiate()
		else:
			bubble = received_bubble_scene.instantiate()
		bubble.custom_minimum_size.y = 100
		if bubble.has_method("setup"):
			bubble.setup(msg.text, msg.time)
		messages_container.add_child(bubble)
		if msg.sent:
			await get_tree().process_frame
			bubble.offset_transform_position.x = 1000
