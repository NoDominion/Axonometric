@tool
extends Polygon2D
class_name VertexTransformer


# func _process(_delta):
# 	print(get_transformed_vertices())


func get_transformed_vertices(angle: float, proportions: Vector2) -> PackedVector2Array:
	var result: PackedVector2Array = polygon
	result = scale_vertices(result, proportions)
	result = rotate_vertices(result, angle)
	return result


func scale_vertices(vertices: PackedVector2Array, proportions: Vector2) -> PackedVector2Array:
	var result: PackedVector2Array = []
	for vertex in vertices:
		result.push_back(vertex * proportions)
	return result


func rotate_vertices(vertices: PackedVector2Array, angle: float) -> PackedVector2Array:
	var result = PackedVector2Array()
	for vertex in vertices:
		result.push_back(vertex.rotated(angle))
	return result
