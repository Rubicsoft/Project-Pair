extends Node2D

# Attach sementara ke root node obstacle (misal Obs1), jalankan scene ini (F6),
# baca detail tiap CollisionShape2D yang ketemu di panel Output.

func _ready() -> void:
	var shapes := find_children("*", "CollisionShape2D", true, false)
	print("Jumlah CollisionShape2D ditemukan: ", shapes.size())

	var total_rect := Rect2()
	var first := true

	for child in shapes:
		var shape: CollisionShape2D = child
		print("- Node: ", shape.name, " | shape resource: ", shape.shape, " | global_position: ", shape.global_position)

		if shape.shape == null:
			print("  -> DILEWATI karena shape kosong (belum di-assign)")
			continue

		var extents: Vector2 = shape.shape.get_rect().size
		var rect := Rect2(shape.global_position - extents / 2.0, extents)
		print("  -> extents: ", extents, " | rect: ", rect)

		if first:
			total_rect = rect
			first = false
		else:
			total_rect = total_rect.merge(rect)

	var center := total_rect.get_center()
	var offset := center - global_position

	print("--- HASIL AKHIR ---")
	print("Width: ", total_rect.size.x)
	print("Height: ", total_rect.size.y)
	print("Center Offset: (", offset.x, ", ", offset.y, ")")
