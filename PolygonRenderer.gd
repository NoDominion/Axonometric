@tool
extends Node2D

enum Shapes { 
	SQUARE, 
	STAR, 
	}

@export var shape: Shapes = Shapes.SQUARE
@export var base_scale: float = 64.0
@export var base_colour: Color = Color.BLACK
@export var polygon_scale: Vector3 = Vector3(1.0, 1.0, 1.0)
@export_range(0.0, 360.0) var polygon_rotation: float = 45.0

@export_range(0.001, 1.0) var ratio: float = 0.5


func get_polygon() -> VertexTransformer:
	match shape:
		Shapes.SQUARE:
			return $Square
		Shapes.STAR:
			return $Star
	
	return $Polygon2D


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
	#print(calculate_proportion())
	return (get_vertex(deg_to_rad(0.0)) - get_vertex(deg_to_rad(90.0))).length() * calculate_proportion()


func get_vertex(angle: float) -> Vector2:
	var length = base_scale / 2
	var x = length * cos(angle)
	var y = length * ratio * sin(angle)
	return Vector2(x, y)


func polygon_to_ratio() -> PackedVector2Array:
	var vertices = PackedVector2Array()
	for vertex in get_polygon().get_transformed_vertices(deg_to_rad(polygon_rotation), Vector2(polygon_scale.x, polygon_scale.y)):
		vertices.push_back(Vector2(vertex.x, vertex.y * ratio))
	return vertices


func _draw():

	var vertices = polygon_to_ratio()

	for i in range(vertices.size()):
		var scaler: float = base_scale / 2 / sqrt(2)
		var height_vector: Vector2 = Vector2(0.0, get_height() * polygon_scale.z)

		var vertex: Vector2 = vertices[i] * scaler
		var next_vertex: Vector2 = vertices[(i + 1) % vertices.size()] * scaler
		draw_line(vertex, next_vertex, base_colour, 1.0)
		draw_line(vertex, vertex - height_vector, base_colour, 1.0)
		draw_line(vertex - height_vector, next_vertex - height_vector, base_colour, 1.0)
