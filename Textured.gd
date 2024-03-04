extends CharacterBody2D

@export var column = 0;
@export var max_columns = 15;
@export var row = 0;
@export var max_rows = 15;
@export var move_speed = 400.0;
var atlas = AtlasTexture.new()

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
	velocity = direction * move_speed

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
