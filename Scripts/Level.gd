extends Node

var max_score = 0
var score = 0
var alive_birds
var game_ended = false

func _ready():
	for damageable in get_tree().get_nodes_in_group("Damageable"):
		damageable.connect("exploded", self, "_on_Damageable_exploded")
		max_score += max(damageable.destroy_points, damageable.survive_points)
	alive_birds = get_tree().get_nodes_in_group("Bird")
	var current_bird = change_bird()
	max_score -= current_bird.survive_points
	$GUI.set_max_score(max_score)

func _on_Damageable_exploded(damageable):
	score += damageable.destroy_points
	$GUI.set_score(score)
	yield(get_tree(), "idle_frame")
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() == 0:
		prepare_end()

func _on_Bird_Eliminated(bird):
	var current_bird = change_bird()
	if !current_bird:
		prepare_end()

func change_bird():
	if alive_birds.size() == 0:
		return null
	var current_bird = alive_birds.pop_front()
	current_bird.connect("eliminated", self, "_on_Bird_Eliminated")
	current_bird.attach_to($Slingshot)
	return current_bird

func prepare_end():
	$GUI.display_end_button()

func end_game():
	if game_ended:
		return
	game_ended = true
	while alive_birds.size() > 0:
		var bird = alive_birds.pop_front()
		score += bird.survive_points
		bird.explode()
	$GUI.set_score(score)

func _on_GUI_end_game():
	end_game()
