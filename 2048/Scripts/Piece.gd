extends Node2D


export var value: int
export var next_value: PackedScene

onready var move_tween := $MoveTween
onready var size_tween := $SizeTween
onready var modulate_tween := $ModulateTween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pop_in():
	size_tween.interpolate_property(self, "scale", Vector2(0.1, 0.1), Vector2(1, 1), 0.2, Tween.TRANS_SINE, Tween.EASE_OUT )
	size_tween.start()	 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(new_position: Vector2):
	move_tween.interpolate_property(self, "position", position, new_position, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	move_tween.start()

func remove():
	size_tween.interpolate_property(self, "scale", scale, Vector2(1.5, 1.5), 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	modulate_tween.interpolate_property(self, "modulate", modulate, Color(0, 0, 0, 0), 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()
	modulate_tween.start()


func _on_ModulateTween_tween_completed(object, key):
	if scale == Vector2(1.5, 1.5):
		queue_free()









