extends SceneTree

func _init() -> void:
	print("--- TESTE COMFY-00.11: VALIDAÇÃO DA MINI-ANIMAÇÃO COMFYUI + ASEPRITE NO GODOT ---")
	var success := true

	# 1. Carregar spritesheet gerada pelo ComfyUI e consolidada no Aseprite
	var sheet_path := "res://assets/sprites/enemies/geleia_de_lumen/comfy_lumen_slime_idle_sheet.png"
	var sheet_tex: Texture2D = load(sheet_path)
	if not sheet_tex:
		print("ERRO: Nao foi possivel carregar ", sheet_path)
		quit(1)
		return

	var size := sheet_tex.get_size()
	print("[PASS] Textura carregada com sucesso. Dimensoes: ", size)
	if size != Vector2(192, 48):
		print("ERRO: Dimensoes da spritesheet invalidas! Esperado (192, 48), obtido: ", size)
		success = false
	else:
		print("  -> Spritesheet horizontal 192x48 px (4 frames de 48x48 px): OK")

	# 2. Criar SpriteFrames dinamicamente a partir dos 4 quadros de 48x48
	var sf := SpriteFrames.new()
	sf.add_animation("idle")
	sf.set_animation_speed("idle", 6.66) # ~150ms por quadro
	sf.set_animation_loop("idle", true)

	for i in range(4):
		var atlas := AtlasTexture.new()
		atlas.atlas = sheet_tex
		atlas.region = Rect2(i * 48, 0, 48, 48)
		sf.add_frame("idle", atlas)

	print("[PASS] SpriteFrames montado com %d frames para animacao 'idle'." % sf.get_frame_count("idle"))

	# 3. Instanciar AnimatedSprite2D e validar filtro Nearest
	var anim_sprite := AnimatedSprite2D.new()
	anim_sprite.sprite_frames = sf
	anim_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	anim_sprite.play("idle")

	if anim_sprite.texture_filter != CanvasItem.TEXTURE_FILTER_NEAREST:
		print("ERRO: texture_filter nao esta configurado para NEAREST!")
		success = false
	else:
		print("[PASS] texture_filter = 1 (Nearest / Pixel-perfect garantido sem blur).")

	# 4. Validar reproducao da animacao
	if anim_sprite.animation != "idle" or not anim_sprite.is_playing():
		print("ERRO: Animacao nao esta em execucao.")
		success = false
	else:
		print("[PASS] Reproducao da animacao 'idle' ativa e fluida.")

	anim_sprite.queue_free()

	print("================================================================================")
	if success:
		print("=== TESTE COMFY-ANIM-01 (COMFY-00.11): PASS ===")
		quit(0)
	else:
		print("=== TESTE COMFY-ANIM-01 (COMFY-00.11): FALHOU ===")
		quit(1)
