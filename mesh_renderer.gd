@tool
extends Node2D

@export_range(0.001, 1.0) var inclination: float = 0.5 :
	get:
		return inclination
	set(value):
		base_scale = base_scale_ratio(value)
		queue_redraw()
		print("Inclination: ", rad_to_deg(atan(value)))
		inclination = value
@export var vertex_finder: int = -1 :
	get:
		return vertex_finder
	set(value):
		queue_redraw()
		vertex_finder = value
@export var mesh_translation: Vector3 = Vector3(0.0, 0.0, 0.0):
	get:
		return mesh_translation
	set(value):
		queue_redraw()
		mesh_translation = value
@export var mesh_scale: Vector3 = Vector3(1.0, 1.0, 1.0) :
	get:
		return mesh_scale
	set(value):
		queue_redraw()
		mesh_scale = value
@export_range(-180.0, 180.0) var mesh_roll: float = 0.0 :
	get:
		return mesh_roll
	set(value):
		queue_redraw()
		mesh_roll = value
@export_range(-180.0, 180.0) var mesh_pitch: float = 0.0 :
	get:
		return mesh_pitch
	set(value):
		queue_redraw()
		mesh_pitch = value
@export_range(-180.0, 180.0) var mesh_yaw: float = 0.0 :
	get:
		return mesh_yaw
	set(value):
		queue_redraw()
		mesh_yaw = value

const unit_scale: Vector3 = Vector3(32.0, 32.0, 32.0)
var base_scale: Vector3
@export var mesh: Mesh = null :
	get:
		return mesh
	set(value):
		queue_redraw()
		mesh = value

func _ready() -> void:
	base_scale = base_scale_ratio(inclination)
	queue_redraw()

func get_transformed_vertices() -> PackedVector3Array:
	return transform_vertices(mesh.get_faces())


func transform_vertices(vertices: PackedVector3Array) -> PackedVector3Array:
	var result: PackedVector3Array = []
	for vertex in vertices:
		result.push_back(apply_transforms(vertex))
	return result


func apply_transforms(vertex: Vector3) -> Vector3:
	var translated_result: Vector3 = vertex + mesh_translation
	var scaled_result: Vector3 = (translated_result / base_scale) * unit_scale * mesh_scale
	var roll_result: Vector3 = scaled_result.rotated(Vector3.FORWARD, deg_to_rad(mesh_roll))
	var pitch_result: Vector3 = roll_result.rotated(Vector3.RIGHT, deg_to_rad(mesh_pitch))
	var yaw_result: Vector3 = pitch_result.rotated(Vector3.UP, deg_to_rad(mesh_yaw))
	return yaw_result


func get_2d_vertices(vertices: PackedVector3Array) -> PackedVector2Array:
		var result: PackedVector2Array = []
		for vertex in vertices:
			result.push_back(project_vertex(vertex))
		return result


func y_ratio() -> float:
	var lr_inclination: float = atan(inclination)
	var c_inclination: float = PI / 2 - lr_inclination * 2
	var lr_scale: float = sqrt(1.0 - tan(lr_inclination) * tan(c_inclination))
	var c_scale: float = sqrt(1.0 - pow(tan(lr_inclination), 2))


	return (1 / lr_scale) * c_scale


func project_vertex(vertex: Vector3) -> Vector2:
	var x: float = vertex.x * cos(atan(inclination)) + vertex.z * cos(atan(inclination))
	var y: float = - vertex.y * y_ratio() + vertex.z * sin(atan(inclination)) - vertex.x * sin(atan(inclination))
	return Vector2(x, y)


func _draw():

	var vertices: PackedVector2Array = get_2d_vertices(get_transformed_vertices())
	for i in vertices.size() / 3:
		var surface: PackedVector2Array = []
		surface.push_back(vertices[i * 3])
		surface.push_back(vertices[i * 3 + 1])
		surface.push_back(vertices[i * 3 + 2])
		#draw_surface(surface)
		draw_wireframe(surface)

	draw_edge_finder(vertices)

func draw_surface(surface: PackedVector2Array) -> void:
	draw_colored_polygon(surface, Color.BLACK)


func draw_wireframe(surface: PackedVector2Array) -> void:
	for i in range(surface.size()):
		draw_line(surface[i], surface[(i + 1) % surface.size()], Color.BLACK, 0.33)


func draw_edge_finder(vertices: PackedVector2Array) -> void:
	if vertex_finder < 0 or vertex_finder >= vertices.size():
		return
	var vert1: Vector2 = vertices[vertex_finder]
	var vert2: Vector2 = vertices[vertex_finder + 1]
	print(vert1, vert2)
	print("Length:", (vert1 - vert2).length())
	draw_line(vert1, vert2, Color.RED)


func base_scale_ratio(incline: float) -> Vector3:
	var a: float = atan(incline)
	var ratio: float = cos(a)
	return Vector3(ratio, ratio, ratio)