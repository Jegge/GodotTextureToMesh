extends MeshInstance
tool

export (Texture) var texture: Texture = null setget set_texture
export (Vector3) var pixel_size: Vector3 = Vector3(0.1, 0.1, 0.1) setget set_pixel_size

func set_pixel_size (_pixel_size: Vector3) -> void:
	pixel_size = _pixel_size
	update_mesh()

func set_texture (_texture: Texture) -> void:
	texture = _texture
	update_mesh()

func update_mesh () -> void:
	mesh = ArrayMesh.new()
	if texture == null:
		return

	var surface = SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var image = texture.get_data()
	image.flip_y()
	image.lock()

	for x in image.get_width():
		for y in image.get_height():
			var color = image.get_pixel(x, y)
			if color.a == 0:
				continue
			_add_front(surface, x, y, color)
			_add_back(surface, x, y, color)
			if x == 0 or image.get_pixel(x - 1, y).a == 0:
				_add_right(surface, x, y, color) 
			if x == image.get_width() - 1 or image.get_pixel(x + 1, y).a == 0:
				_add_left(surface, x, y, color)
			if y == 0 or image.get_pixel(x, y - 1).a == 0:
				_add_bottom(surface, x, y, color)
			if y == image.get_width() - 1 or image.get_pixel(x, y + 1).a == 0:
				_add_top(surface, x, y, color)
			
	image.unlock()

	mesh = surface.commit()

	var material = SpatialMaterial.new()
	material.vertex_color_use_as_albedo = true
	mesh.surface_set_material(0, material)
	
func _add_bottom (surface: SurfaceTool, x: float, y: float, color: Color) -> void:
	surface.add_normal(Vector3(0, -1, 0))
	surface.add_color(color)
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, y * pixel_size.y,  pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, y * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, y * pixel_size.y, pixel_size.z))

func _add_top (surface: SurfaceTool, x: float, y: float, color: Color) -> void:
	surface.add_normal(Vector3(0, 1, 0))
	surface.add_color(color)
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3(x * pixel_size.x, (y + 1) * pixel_size.y,  pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3(x * pixel_size.x, (y + 1) * pixel_size.y, 0))
		
func _add_right (surface: SurfaceTool, x: float, y: float, color: Color) -> void:
	surface.add_normal(Vector3(-1, 0, 0))
	surface.add_color(color)
	surface.add_vertex(Vector3(x * pixel_size.x, y * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3(x * pixel_size.x, y * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3(x * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3(x * pixel_size.x, y * pixel_size.y, pixel_size.z))

func _add_left (surface: SurfaceTool, x: float, y: float, color: Color) -> void:
	surface.add_normal(Vector3(1, 0, 0))
	surface.add_color(color)
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))

func _add_front (surface: SurfaceTool, x: float, y: float, color: Color) -> void:
	surface.add_normal(Vector3(0, 0, -1))
	surface.add_color(color)
	surface.add_vertex(Vector3(x       * pixel_size.x, y       * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y       * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3(x       * pixel_size.x, (y + 1) * pixel_size.y, 0))
	surface.add_vertex(Vector3(x       * pixel_size.x, y       * pixel_size.y, 0))

func _add_back (surface: SurfaceTool, x: float, y: float, color: Color) -> void:
	surface.add_normal(Vector3(0, 0, 1))
	surface.add_color(color)
	surface.add_vertex(Vector3(x       * pixel_size.x, y       * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, y       * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3((x + 1) * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3(x       * pixel_size.x, y       * pixel_size.y, pixel_size.z))
	surface.add_vertex(Vector3(x       * pixel_size.x, (y + 1) * pixel_size.y, pixel_size.z))



