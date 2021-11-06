extends Node2D


export var value: int
export var next_value: PackedScene

onready var move_tween := $MoveTween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(new_position: Vector2):
	move_tween.interpolate_property(self, "position", position, new_position, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	move_tween.start()

func remove():
	queue_free()
