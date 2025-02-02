extends Node

var player_dead = false
var number_of_coins = 0

var fish_available = 5
var fish_used = 0
var total_fish = fish_available + fish_used

var new_level := 1

#signal successful_dlc_purchase
var has_level_dlc := false
var has_skin_dlc := false

func save_current_level():
	save_game(SceneChanger.current_level)

func save_next_level():
	new_level = SceneChanger.current_level + 1
	save_game(new_level)

func save_game(level_to_save):
	var save_dict = {
		"level": level_to_save,
		"coins": number_of_coins,
		"fish_available": fish_available,
		"fish_used": fish_used,
		"total_fish": total_fish,
		"level_dlc": has_level_dlc,
		"skin_dlc": has_skin_dlc
	}

	var save_game = File.new()

	save_game.open("user://savegame.trtl", File.WRITE)
	save_game.store_line(to_json(save_dict))

	save_game.close()

func load_save():
	var save_game = File.new()

	# Set level to 1 and quit if no save file exists
	if not save_game.file_exists("user://savegame.trtl"):
		reset_save(save_game)
		return

	save_game.open("user://savegame.trtl", File.READ)
	var save_file = parse_json(save_game.get_line())

	var saved_coins = int(save_file['coins'])
	number_of_coins = saved_coins

	var saved_fish_available = int(save_file['fish_available'])
	fish_available = saved_fish_available

	var saved_fish_used = int(save_file['fish_used'])
	fish_used = saved_fish_used

	var saved_total_fish = int(save_file['total_fish'])
	total_fish = saved_total_fish

	has_level_dlc = save_file['level_dlc']
	has_skin_dlc = save_file['skin_dlc']

	var saved_level = int(save_file['level'])
	SceneChanger.current_level = saved_level
	save_game.close()

func reset_save(save_game):
	SceneChanger.current_level = 1
	number_of_coins = 0
	fish_available = 5
	fish_used = 0
	total_fish = fish_available + fish_used
	save_game.close();
	save_game(1)

func _on_successful_dlc_purchase(bought_level, bought_skin):
	# only set the variables if we bought a dlc
	# we dont want to overwrite dlc bought in the past
	if bought_level:
		has_level_dlc = bought_level
	if bought_skin:
		has_skin_dlc = bought_skin
	save_current_level()
