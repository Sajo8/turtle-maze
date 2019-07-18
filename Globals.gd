extends Node

var player_dead = false

func save_current_level():
	save_game(SceneChanger.current_level)

func save_next_level():
	var next_level = SceneChanger.current_level + 1
	if next_level >  SceneChanger.levels.size(): # Don't save if they just finished the max level
		return
	else:
		save_game(SceneChanger.current_level + 1)

func save_game(level_to_save):
	var save_dict = {
		"level": level_to_save
	}

	var save_game = File.new()

	save_game.open("user://savegame.trtl", File.WRITE)
	save_game.store_line(to_json(save_dict))

	save_game.close()

func load_save():
	var save_game = File.new()

	# Set level to 1 and quit if no save file exists
	if not save_game.file_exists("user://savegame.trtl"):
		SceneChanger.current_level = 1
		save_game.close()
		return

	save_game.open("user://savegame.trtl", File.READ)
	var saved_level = parse_json(save_game.get_line())
	saved_level = int(saved_level['level'])
	SceneChanger.current_level = saved_level

	save_game.close()