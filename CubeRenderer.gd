@tool
extends Node2D

@export var base_scale: float
@export var base_colour: Color = Color.BLACK
@export_range(0.0, 10.0) var width: float = 1.0
@export_range(0.0, 10.0) var depth: float = 1.0
@export_range(0.0, 10.0) var height: float = 1.0

@export_range(0.001, 1.0) var ratio: float = 0.5


func _process(_delta) -> void:
	queue_redraw()


func get_inclination() -> float:
	return atan(ratio)


func calculate_centre_inclination() -> float:
	return deg_to_rad(90 - rad_to_deg(get_inclination()) * 2)


func calculate_scale() -> float:
	return sqrt(1.0 - tan(get_inclination()) * tan(calculate_centre_inclination()))


func calculate_centre_scale() -> float:
	return sqrt(1.0 - pow(tan(get_inclination()), 2))


func calculate_proportion() -> float:
	return calculate_centre_scale() / calculate_scale()

# Something wrong with this. The width of the cube shouldn't change when you change the ratio
func calculate_right_vector() -> Vector2:
	# var x = base_scale * cos(-get_inclination())
	# var y = base_scale * sin(-get_inclination())
	# return Vector2(x, y)
	return Vector2(base_scale / 2, - base_scale / 2 * ratio)


func calculate_up_vector() -> Vector2:
	# return Vector2(0.0, -base_scale * calculate_proportion())
	var length = calculate_right_vector().length()
	return Vector2(0.0, -length * calculate_proportion())


func calculate_left_vector() -> Vector2:
	# var x = base_scale * cos(PI + get_inclination())
	# var y = base_scale * sin(PI + get_inclination())
	# return Vector2(x, y)
	return Vector2(- base_scale / 2, - base_scale / 2 * ratio)


func _draw():

	var right_vector: Vector2 = calculate_right_vector() * width
	var left_vector: Vector2 = calculate_left_vector() * depth
	var up_vector: Vector2 = calculate_up_vector() * height

	var v0: Vector2 = Vector2.ZERO # bottom centre
	var v1: Vector2 = v0 + right_vector # right
	var v2: Vector2 = v0 + left_vector # left
	var v3: Vector2 = v0 + up_vector # centre
	var v4: Vector2 = v1 + up_vector # top right
	var v5: Vector2 = v2 + up_vector # top left
	var v6: Vector2 = v4 + left_vector # top back

	#var full_array: PackedVector2Array = [v0, v1, v4, v6, v5, v2]
	var left_array: PackedVector2Array = [v0, v2, v5, v3]
	var right_array: PackedVector2Array = [v0, v1, v4, v3]
	var top_array: PackedVector2Array = [v3, v5, v6, v4]

	draw_colored_polygon(left_array, base_colour.darkened(0.5)) # left
	draw_colored_polygon(right_array, base_colour) # right
	draw_colored_polygon(top_array, base_colour.lightened(0.5)) # top


	draw_line(v0, v3, base_colour.lightened(0.75), 1.0, false) # centre vertical
	draw_line(v3, v4, base_colour.lightened(0.75), 1.0, false) # centre right
	draw_line(v3, v5, base_colour.lightened(0.75), 1.0, false) # centre left

	draw_line(v0, v1, base_colour.darkened(1.0), 1.0, false) # bottom right
	draw_line(v0, v2, base_colour.darkened(1.0), 1.0, false) # bottom left

	draw_line(v1, v4, base_colour.darkened(0.5), 1.0, false) # right
	draw_line(v2, v5, base_colour.darkened(1.0), 1.0, false) # left

	draw_line(v4, v6, base_colour, 1.0, false) # top right
	draw_line(v5, v6, base_colour, 1.0, false) # top left

