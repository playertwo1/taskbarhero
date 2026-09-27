extends SceneTree

func _init() -> void:
	print("\n--- TESTE R11: VALIDACAO TECNICA E VISUAL DO ELITE LOBO ALFA DE LUMEN ---")
	
	var scene_path := "res://scenes/enemies/LoboAlfaDeLumen.tscn"
	var packed_scene: PackedScene = load(scene_path)
	assert(packed_scene != null, "Falha ao carregar cena do Lobo Alfa")
	
	var instance = packed_scene.instantiate()
	assert(instance != null, "Falha ao instanciar Lobo Alfa")
	
	var anim_sprite: AnimatedSprite2D = instance.get_node_or_null("AnimatedSprite2D")
	assert(anim_sprite != null, "AnimatedSprite2D nao encontrado na cena")
	
	# 1. Validar 16 frames canonicos
	var frames: SpriteFrames = anim_sprite.sprite_frames
	assert(frames != null, "SpriteFrames nulo")
	
	var idle_cnt := frames.get_frame_count("idle")
	var atk_cnt := frames.get_frame_count("attack")
	var hit_cnt := frames.get_frame_count("hit")
	var death_cnt := frames.get_frame_count("death")
	
	print("  [INFO] Frames detectados - Idle: %d, Atk: %d, Hit: %d, Death: %d" % [idle_cnt, atk_cnt, hit_cnt, death_cnt])
	assert(idle_cnt == 4, "Idle deve ter 4 frames")
	assert(atk_cnt == 4, "Attack deve ter 4 frames")
	assert(hit_cnt == 2, "Hit deve ter 2 frames")
	assert(death_cnt == 6, "Death deve ter 6 frames")
	print("  [PASS] 16 frames canonicos verificados")
	
	# 2. Validar spritesheet
	var first_tex = frames.get_frame_texture("idle", 0)
	assert(first_tex != null, "Textura nula no frame idle 0")
	var sheet_size: Vector2 = first_tex.atlas.get_size()
	print("  [INFO] Dimensoes da spritesheet: %s" % str(sheet_size))
	assert(sheet_size == Vector2(768, 48), "Spritesheet deve ter 768x48 px")
	print("  [PASS] Spritesheet validada: (768.0, 48.0)")
	
	# 3. Validar Nearest Texture Filter
	assert(anim_sprite.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST, "Texture filter deve ser Nearest (1)")
	print("  [PASS] texture_filter = 1 (Nearest)")
	
	# 4. Validar offset baseline
	assert(anim_sprite.offset == Vector2(0, -20), "Offset deve ser Vector2(0, -20) para 48x48 baseline Y=44")
	print("  [PASS] offset = Vector2(0, -20)")
	
	# 5. Validar ciclo de animacoes do controller
	instance._ready()
	instance.play_idle()
	assert(anim_sprite.animation == "idle", "Deveria estar em idle")
	
	instance.play_attack()
	assert(anim_sprite.animation == "attack", "Deveria estar em attack")
	
	instance.play_hit()
	assert(anim_sprite.animation == "hit", "Deveria estar em hit")
	
	instance.play_death()
	assert(anim_sprite.animation == "death", "Deveria estar em death")
	assert(instance.is_dead == true, "is_dead deveria ser true apos play_death")
	
	instance.reset()
	assert(anim_sprite.animation == "idle", "Reset deveria restaurar idle")
	assert(instance.is_dead == false, "is_dead deveria ser false apos reset")
	print("  [PASS] Ciclo de animacoes do controller validado")
	
	instance.free()
	
	print("\n================================================================================")
	print("=== ELITE LOBO ALFA DE LUMEN VALIDADO COM SUCESSO: PASS ===")
	print("================================================================================\n")
	quit(0)
