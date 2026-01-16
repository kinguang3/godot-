extends Node
@onready var score_timer: Timer = $ScoreTimer
@onready var mob_timer: Timer = $MobTimer
@onready var start_timer: Timer = $StartTimer
@onready var player: Area2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var music: AudioStreamPlayer2D = $Music
@onready var deathsound: AudioStreamPlayer2D = $Deathsound

@export var mob_scene:PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.


func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()
	music.stop()
	deathsound.play()
	pass # Replace with function body.


func new_game():
	score = 0
	player.start(player.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	music.play()



func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()
	pass # Replace with function body.


func _on_score_timer_timeout() -> void:
	score+=1
	hud.update_score(score)
	pass # Replace with function body.
