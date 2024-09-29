@tool
extends Node2D

@export var base_scale: float
@export var base_colour: Color = Color.BLACK
@export_range(0.0, 10.0) var width: float = 1.0
@export_range(0.0, 10.0) var depth: float = 1.0
@export_range(0.0, 10.0) var height: float = 1.0

@export_range(0.001, 1.0) var ratio: float = 0.5
@export_range(0.0, 360.0) var spin: float = 0.0


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

func get_height() -> float:
	return (get_vertex(deg_to_rad(0.0)) - get_vertex(deg_to_rad(90.0))).length() * calculate_proportion()


func get_vertex(angle: float) -> Vector2:
	var length = base_scale / 2
	var x = length * cos(angle)
	var y = length * ratio * sin(angle)
	return Vector2(x, y)


func get_scaled_vertex(angle: float) -> Vector2:
	var a = base_scale / 2 * depth
	var b = base_scale / 2 * width
	var length = sqrt(pow(a, 2) + pow(b, 2))

	var x = length * cos(angle + atan(b/a) - deg_to_rad(45.0))
	var y = length * ratio * sin(angle+ atan(b/a) - deg_to_rad(45.0))
	return Vector2(x, y)


func _draw():

	var v0: Vector2 = get_vertex(deg_to_rad(0.0 + spin))
	var v1: Vector2 = get_vertex(deg_to_rad(90.0 + spin))
	var v2: Vector2 = get_vertex(deg_to_rad(180.0 + spin))
	var v3: Vector2 = get_vertex(deg_to_rad(270.0 + spin))
	var height_offset = Vector2(0.0, -get_height())
	var v4: Vector2 = v0 + height_offset
	var v5: Vector2 = v1 + height_offset
	var v6: Vector2 = v2 + height_offset
	var v7: Vector2 = v3 + height_offset

	draw_line(v0, v1, base_colour, 1.0, false)
	draw_line(v1, v2, base_colour, 1.0, false)
	draw_line(v2, v3, base_colour, 1.0, false)
	draw_line(v3, v0, base_colour, 1.0, false)

	draw_line(v4, v5, base_colour, 1.0, false)
	draw_line(v5, v6, base_colour, 1.0, false)
	draw_line(v6, v7, base_colour, 1.0, false)
	draw_line(v7, v4, base_colour, 1.0, false)

	draw_line(v0, v4, base_colour, 1.0, false)
	draw_line(v1, v5, base_colour, 1.0, false)
	draw_line(v2, v6, base_colour, 1.0, false)
	draw_line(v3, v7, base_colour, 1.0, false)
