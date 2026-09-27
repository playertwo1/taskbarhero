extends SceneTree

func _init() -> void:
	print("--- TESTE R9: VALIDAÇÃO TÉCNICA E VISUAL DA GELEIA DE LÚMEN ---")
	var success := true
	
	# 1. Carregar cena GeleiaDeLumen
	var slime_scene: PackedScene = load("res://scenes/enemies/GeleiaDeLumen.tscn")
	if not slime_scene:
		print("ERRO: Falha ao carregar scenes/enemies/GeleiaDeLumen.tscn")
		quit(1)
		return
	
	var slime_node: Node2D = slime_scene.instantiate()
	var anim_sprite: AnimatedSprite2D = slime_node.get_node_or_null("AnimatedSprite2D")
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
	var sheet_tex: Texture2D = load("res://assets/sprites/enemies/geleia_de_lumen/enemy_geleia_lumen_sheet.png")
	if not sheet_tex:
		print("ERRO: Não foi possível carregar a textura do spritesheet")
		success = false
	else:
		var size := sheet_tex.get_size()
		if size != Vector2(512, 32):
			print("ERRO: Dimensões da textura: ", size, ", esperado 512x32")
			success = false
		else:
			print("[PASS] Dimensões do spritesheet confirmadas: 512x32 (16 frames de 32x32)")
	
	# 3. Testar métodos do controller GeleiaDeLumen.gd
	slime_node.play_idle()
	slime_node.play_attack()
	slime_node.play_hit()
	slime_node.play_death()
	if not slime_node.is_dead:
		print("ERRO: is_dead deveria ser true após play_death")
		success = false
	slime_node.reset()
	if slime_node.is_dead:
		print("ERRO: is_dead deveria ser false após reset")
		success = false
	print("[PASS] Ciclo de transição de estados do script GeleiaDeLumen.gd validado")
	
	slime_node.free()
	
	if success:
		print("=== GATE R9 VALIDADO COM SUCESSO: PIPELINE ARTÍSTICO PROVADO ===")
		quit(0)
	else:
		print("=== GATE R9 FALHOU ===")
		quit(1)
