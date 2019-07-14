extends CanvasLayer

onready var animation_player = $AnimationPlayer

var levels = {
	1: "dirt/Level_1",
	2: "dirt/Level_2",
}

var current_level = 1
var max_levels = levels.size()

func fade_out():
	animation_player.play("fade")

func fade_in():
	animation_player.play_backwards("fade")

func go_to_level(new_level):
	# Prevent going any further if we're already at the highest level there is
	if new_level > max_levels:
		return

	fade_out()
	yield(animation_player, "animation_finished")

	# Make new path for scene to be switched
	var new_level_path = "res://levels/" + levels[new_level] + ".tscn"
	# Switch scene
	get_tree().change_scene(new_level_path)

	# Switched scenes, let's update current level number
	current_level = new_level

	fade_in()
	yield(animation_player, "animation_finished")

	Globals.save_game()

func go_to_next_level():

	# Make temp var for next level
	var next_level = current_level + 1

	go_to_level(next_level)