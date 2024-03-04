extends CharacterBody2D

@export var column = 0;
@export var max_columns = 15;
@export var row = 0;
@export var max_rows = 15;
@export var move_speed = 400.0;
@export var arrow = preload("res://arrow.tscn")
var atlas = AtlasTexture.new()
var last_direction = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	var atlas_image = Image.new()
	atlas_image.load("res://assets/textures/lofi_char.png")
	var atlas_texture = ImageTexture.create_from_image(atlas_image)
	atlas.atlas = atlas_texture
	var region = Rect2(Vector2(column * 8, row * 8), Vector2(8, 8))
	atlas.region = region
	var sprite = Sprite2D.new()
	sprite.texture = atlas
	add_child(sprite)
	pass # Replace with function body.

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# clamp the direction vector components to -1, 0, or 1
	if direction.x > 0:
		direction.x = 1
	elif direction.x < 0:
		direction.x = -1
	if direction.y > 0:
		direction.y = 1
	elif direction.y < 0:
		direction.y = -1

	if direction != Vector2(0, 0):
		last_direction = direction

	velocity = direction.normalized() * move_speed

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Use qe keys to change the sprite atlas region
	if Input.is_action_just_pressed("previous_sprite"):
		column -= 1
		if column < 0:
			column = 0
			row -= 1
			if row < 0:
				row = 0
		var region = Rect2(Vector2(column * 8, row * 8), Vector2(8, 8))
		atlas.region = region
	if Input.is_action_just_pressed("next_sprite"):
		column += 1
		if column > max_columns:
			column = 15
			row += 1
			if row > max_rows:
				row = max_rows
		var region = Rect2(Vector2(column * 8, row * 8), Vector2(8, 8))
		atlas.region = region

	if Input.is_action_just_pressed("attack_1"):
		var new_arrow = arrow.instantiate()
		new_arrow.set_position(get_position() + last_direction * 10)
		new_arrow.set_direction(last_direction)
		get_parent().add_child(new_arrow)
		print("attack 1")

	if Input.is_action_just_pressed("attack_2"):
		print("attack 2")
	
	if Input.is_action_just_pressed("attack_3"):
		print("attack 3")
