extends Sprite

func _ready():
	$AnimationPlayer.play("default")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
