extends SceneTree

func _init() -> void:
	print("--- TESTE R11: VALIDAÇÃO TÉCNICA E VISUAL DA HEROÍNA ÍRIS ---")
	var success := true

	# 1. Carregar cena Iris
	var iris_scene: PackedScene = load("res://scenes/heroes/Iris.tscn")
	if not iris_scene:
		print("ERRO: Falha ao carregar scenes/heroes/Iris.tscn")
		quit(1)
		return

	var iris_node: Node2D = iris_scene.instantiate()
	var anim_sprite: AnimatedSprite2D = iris_node.get_node_or_null("AnimatedSprite2D")
	if not anim_sprite or not anim_sprite.sprite_frames:
		print("ERRO: AnimatedSprite2D ou SpriteFrames ausente na cena")
		quit(1)
		return

	var sf: SpriteFrames = anim_sprite.sprite_frames
	var anims := sf.get_animation_names()
	print("[PASS] Animações encontradas no SpriteFrames: ", anims)

	var required_anims := {
		"idle": 4,
		"attack": 4,
		"hit": 2,
		"death": 6
	}

	var total_frames := 0
	for anim_name in required_anims.keys():
		if not sf.has_animation(anim_name):
			print("ERRO: Animação obrigatória ausente: ", anim_name)
			success = false
		else:
			var fc := sf.get_frame_count(anim_name)
			var expected_fc: int = required_anims[anim_name]
			total_frames += fc
			if fc != expected_fc:
				print("ERRO: Animação '%s' tem %d frames, esperado %d" % [anim_name, fc, expected_fc])
				success = false
			else:
				print("  -> Animação '%s': %d frames (OK)" % [anim_name, fc])

	if total_frames != 16:
		print("ERRO: Total de frames é %d, esperado 16" % total_frames)
		success = false
	else:
		print("[PASS] Contagem total de frames validada: 16/16")

	# 2. Validar dimensões da textura importada
	var sheet_tex: Texture2D = load("res://assets/sprites/heroes/iris/hero_iris_sheet.png")
	if not sheet_tex:
		print("ERRO: Não foi possível carregar a textura do spritesheet de Íris")
		success = false
	else:
		var size := sheet_tex.get_size()
		if size != Vector2(768, 48):
			print("ERRO: Dimensões da textura: ", size, ", esperado 768x48")
			success = false
		else:
			print("[PASS] Dimensões do spritesheet confirmadas: 768x48 (16 frames de 48x48)")

	# 3. Validar texture_filter
	if anim_sprite.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
		print("ERRO: texture_filter não é NEAREST")
		success = false
	else:
		print("[PASS] texture_filter = 1 (Nearest / pixel-perfection)")

	# 4. Testar métodos do controller Iris.gd
	iris_node.play_idle()
	iris_node.play_attack()
	iris_node.play_hit()
	iris_node.play_death()
	if not iris_node.is_dead:
		print("ERRO: is_dead deveria ser true após play_death")
		success = false
	iris_node.reset()
	if iris_node.is_dead:
		print("ERRO: is_dead deveria ser false após reset")
		success = false
	print("[PASS] Ciclo de transição de estados do script Iris.gd validado")

	iris_node.free()

	if success:
		print("=== HEROÍNA ÍRIS VALIDADA COM SUCESSO: REQUISITOS TÉCNICOS PASS ===")
		quit(0)
	else:
		print("=== HEROÍNA ÍRIS FALHOU ===")
		quit(1)
