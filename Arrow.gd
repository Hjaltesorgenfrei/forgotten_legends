extends CharacterBody2D


const SPEED = 600.0
var direction = Vector2()
var area = Area2D.new()
# Get the gravity from the project settings to be synced with RigidBody nodes
@export var arrow_texture = ArrowTexture.STEEL

enum ArrowTexture {
	STEEL,
	WOOD,
	RED,
	BLUE,
	PINK,
	GREEN,
	DART,
}

func texture_to_column_row(texture):
	match texture:
		ArrowTexture.STEEL: return Vector2(0, 15)
		ArrowTexture.WOOD: return Vector2(8, 15)
		ArrowTexture.RED: return Vector2(0, 13)
		ArrowTexture.BLUE: return Vector2(0, 14)
		ArrowTexture.PINK: return Vector2(8, 14)
		ArrowTexture.GREEN: return Vector2(8, 13)
		ArrowTexture.DART: return Vector2(6, 5)
		_: return Vector2(0, 15)

func set_direction(new_direction):
	direction = new_direction

func direction_to_column(in_direction):
	# down = 0, down left = 1, left = 2, up left = 3, up = 4, up right = 5, right = 6, down right = 7
	match in_direction:
		Vector2(0, 1): return 0
		Vector2(-1, 1): return 1
		Vector2(-1, 0): return 2
		Vector2(-1, -1): return 3
		Vector2(0, -1): return 4
		Vector2(1, -1): return 5
		Vector2(1, 0): return 6
		Vector2(1, 1): return 7
		_: return 0

func _ready():
	var atlas = AtlasTexture.new()
	var atlas_image = Image.new()
	atlas_image.load("res://assets/textures/lofi_obj.png")
	var atlas_texture = ImageTexture.create_from_image(atlas_image)
	atlas.atlas = atlas_texture
	var column = direction_to_column(direction)
	var type = texture_to_column_row(arrow_texture)
	type.x += column
	var region = Rect2(type * 8, Vector2(8, 8))
	atlas.region = region
	var sprite = Sprite2D.new()
	sprite.texture = atlas
	add_child(sprite)

	# rotate collision shape to match the sprite

	var collision_shape = CollisionShape2D.new()
	var shape = SegmentShape2D.new()
	shape.a = Vector2(3 * direction.x, -3 * direction.y)
	shape.b = Vector2(-3 * direction.x, 3 * direction.y)
	collision_shape.shape = shape
	area.add_child(collision_shape)
	add_child(area)


func _physics_process(delta):
	velocity = direction * SPEED
	
	if area.get_overlapping_bodies().size() > 0:
		direction = Vector2()

	move_and_slide()
