extends SceneTree

func _init() -> void:
	print("--- TESTE R11: VALIDAÇÃO TÉCNICA E VISUAL DOS MOBS DO BOSQUE DE LÚMEN ---")
	var success := true

	var mobs_to_test := [
		{
			"id": "gremlin_de_folha",
			"scene": "res://scenes/enemies/GremlinDeFolha.tscn",
			"sheet": "res://assets/sprites/enemies/gremlin_de_folha/mob_gremlin_folha_sheet.png",
			"size": Vector2(512, 32)
		},
		{
			"id": "javali_de_musgo",
			"scene": "res://scenes/enemies/JavaliDeMusgo.tscn",
			"sheet": "res://assets/sprites/enemies/javali_de_musgo/mob_javali_musgo_sheet.png",
			"size": Vector2(768, 48)
		},
		{
			"id": "espirito_de_raiz",
			"scene": "res://scenes/enemies/EspiritoDeRaiz.tscn",
			"sheet": "res://assets/sprites/enemies/espirito_de_raiz/mob_espirito_raiz_sheet.png",
			"size": Vector2(768, 48)
		}
	]

	var required_anims := {
		"idle": 4,
		"attack": 4,
		"hit": 2,
		"death": 6
	}

	for mob in mobs_to_test:
		var mob_id: String = mob["id"]
		var scene_path: String = mob["scene"]
		var sheet_path: String = mob["sheet"]
		var expected_size: Vector2 = mob["size"]

		print("\n[VALIDANDO MOB: %s]" % mob_id)
		var pscene: PackedScene = load(scene_path)
		if not pscene:
			print("ERRO: Falha ao carregar cena: ", scene_path)
			success = false
			continue

		var node: Node2D = pscene.instantiate()
		var anim: AnimatedSprite2D = node.get_node_or_null("AnimatedSprite2D")
		if not anim or not anim.sprite_frames:
			print("ERRO: AnimatedSprite2D ou SpriteFrames ausente em: ", mob_id)
			success = false
			node.free()
			continue

		var sf: SpriteFrames = anim.sprite_frames
		var total_frames := 0
		for a_name in required_anims.keys():
			if not sf.has_animation(a_name):
				print("ERRO: Animacao '%s' ausente em: %s" % [a_name, mob_id])
				success = false
			else:
				var fc := sf.get_frame_count(a_name)
				var exp_fc: int = required_anims[a_name]
				total_frames += fc
				if fc != exp_fc:
					print("ERRO: Animacao '%s' em %s tem %d frames, esperado %d" % [a_name, mob_id, fc, exp_fc])
					success = false

		if total_frames != 16:
			print("ERRO: Total de frames em %s e %d, esperado 16" % [mob_id, total_frames])
			success = false
		else:
			print("  [PASS] 16 frames canonicos verificados")

		var tex: Texture2D = load(sheet_path)
		if not tex:
			print("ERRO: Falha ao carregar textura: ", sheet_path)
			success = false
		elif tex.get_size() != expected_size:
			print("ERRO: Dimensoes da textura %s: %s, esperado %s" % [mob_id, tex.get_size(), expected_size])
			success = false
		else:
			print("  [PASS] Spritesheet validada: ", expected_size)

		if anim.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
			print("ERRO: texture_filter nao e NEAREST em: ", mob_id)
			success = false
		else:
			print("  [PASS] texture_filter = 1 (Nearest)")

		# Transições
		node.play_idle()
		node.play_attack()
		node.play_hit()
		node.play_death()
		if not node.is_dead:
			print("ERRO: is_dead deveria ser true apos play_death em: ", mob_id)
			success = false
		node.reset()
		if node.is_dead:
			print("ERRO: is_dead deveria ser false apos reset em: ", mob_id)
			success = false
		print("  [PASS] Ciclo de animacoes do controller validado")

		node.free()

	print("\n================================================================================")
	if success:
		print("=== TODOS OS MOBS DO BOSQUE DE LUMEN VALIDADOS COM SUCESSO: PASS ===")
		quit(0)
	else:
		print("=== FALHA NA VALIDACAO DOS MOBS ===")
		quit(1)
