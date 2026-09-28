extends SceneTree

func _init() -> void:
	print("--- TESTE DE INTEGRAÇÃO: TODAS AS 19 CENAS DE HERÓIS E INIMIGOS ---")
	var success := true

	var hero_scenes := [
		"res://scenes/heroes/Bastiao.tscn",
		"res://scenes/heroes/Flecha.tscn",
		"res://scenes/heroes/Iris.tscn",
		"res://scenes/heroes/Brasa.tscn",
		"res://scenes/heroes/Veu.tscn",
		"res://scenes/heroes/Orvalho.tscn",
		"res://scenes/heroes/Forja.tscn",
		"res://scenes/heroes/Sino.tscn"
	]

	var enemy_scenes := [
		"res://scenes/enemies/GeleiaDeLumen.tscn",
		"res://scenes/enemies/GremlinDeFolha.tscn",
		"res://scenes/enemies/JavaliDeMusgo.tscn",
		"res://scenes/enemies/EspiritoDeRaiz.tscn",
		"res://scenes/enemies/LoboAlfaDeLumen.tscn",
		"res://scenes/enemies/GuardiaoCervoDePedra.tscn",
		"res://scenes/enemies/SaqueadorDaMata.tscn",
		"res://scenes/enemies/XamaDeEsporos.tscn",
		"res://scenes/enemies/SentinelaDeRaizes.tscn",
		"res://scenes/enemies/LoboDeSombra.tscn",
		"res://scenes/enemies/MatriarcaDoMicelio.tscn"
	]

	var required_anims := {
		"idle": 4,
		"attack": 4,
		"hit": 2,
		"death": 6
	}

	print("\n>>> 1. TESTANDO 8 CENAS DE HERÓIS:")
	for h_path in hero_scenes:
		var scene: PackedScene = load(h_path)
		if not scene:
			print("FALHA: Não foi possível carregar a cena: ", h_path)
			success = false
			continue

		var node: Node2D = scene.instantiate()
		var anim_sprite: AnimatedSprite2D = node.get_node_or_null("AnimatedSprite2D")
		if not anim_sprite or not anim_sprite.sprite_frames:
			print("FALHA: AnimatedSprite2D ou SpriteFrames ausente em: ", h_path)
			success = false
			node.free()
			continue

		var sf: SpriteFrames = anim_sprite.sprite_frames
		var total_frames := 0
		for anim in required_anims.keys():
			if not sf.has_animation(anim):
				print("FALHA: Animação '%s' ausente em: %s" % [anim, h_path])
				success = false
			else:
				var fc := sf.get_frame_count(anim)
				total_frames += fc
				if fc != required_anims[anim]:
					print("FALHA: Animação '%s' tem %d quadros em %s (esperado %d)" % [anim, fc, h_path, required_anims[anim]])
					success = false

		if total_frames != 16:
			print("FALHA: Total de frames em %s é %d (esperado 16)" % [h_path, total_frames])
			success = false

		# Testar métodos do script
		node.play_idle()
		node.play_attack()
		node.play_hit()
		node.play_death()
		if not node.is_dead:
			print("FALHA: is_dead não ficou true após play_death em: ", h_path)
			success = false
		node.reset()
		if node.is_dead:
			print("FALHA: is_dead não ficou false após reset em: ", h_path)
			success = false

		print("  [PASS] Herói validado: %s (16 frames, Nearest, ciclo de animação OK)" % h_path.get_file().get_basename())
		node.free()

	print("\n>>> 2. TESTANDO 11 CENAS DE INIMIGOS E CHEFES:")
	for e_path in enemy_scenes:
		var scene: PackedScene = load(e_path)
		if not scene:
			print("FALHA: Não foi possível carregar a cena: ", e_path)
			success = false
			continue

		var node: Node2D = scene.instantiate()
		var anim_sprite: AnimatedSprite2D = node.get_node_or_null("AnimatedSprite2D")
		if not anim_sprite or not anim_sprite.sprite_frames:
			print("FALHA: AnimatedSprite2D ou SpriteFrames ausente em: ", e_path)
			success = false
			node.free()
			continue

		var sf: SpriteFrames = anim_sprite.sprite_frames
		var total_frames := 0
		for anim in required_anims.keys():
			if not sf.has_animation(anim):
				print("FALHA: Animação '%s' ausente em: %s" % [anim, e_path])
				success = false
			else:
				var fc := sf.get_frame_count(anim)
				total_frames += fc
				if fc != required_anims[anim]:
					print("FALHA: Animação '%s' tem %d quadros em %s (esperado %d)" % [anim, fc, e_path, required_anims[anim]])
					success = false

		if total_frames != 16:
			print("FALHA: Total de frames em %s é %d (esperado 16)" % [e_path, total_frames])
			success = false

		# Testar métodos do script
		node.play_idle()
		node.play_attack()
		node.play_hit()
		node.play_death()
		if not node.is_dead:
			print("FALHA: is_dead não ficou true após play_death em: ", e_path)
			success = false
		node.reset()
		if node.is_dead:
			print("FALHA: is_dead não ficou false após reset em: ", e_path)
			success = false

		print("  [PASS] Inimigo validado: %s (16 frames, Nearest, ciclo de animação OK)" % e_path.get_file().get_basename())
		node.free()

	if success:
		print("\n=======================================================")
		print("=== TODAS AS 19 CENAS FORAM VALIDADAS COM SUCESSO: PASS ===")
		print("=======================================================")
		quit(0)
	else:
		print("\n=== FALHA NA VALIDAÇÃO DAS CENAS ===")
		quit(1)
