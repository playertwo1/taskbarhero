extends RefCounted
class_name ItemIconResolver

## Utilitário de mapeamento e carregamento de ícones de itens e Ecos (64×64 e 32×32).
## Suporta mapeamento por ID runtime (ex: "item_w_001"), design_id ("ITEM_W_001") ou dicionário de instância.

const ICONS_64_DIR := "res://assets/sprites/items/icons_64/"
const ICONS_32_DIR := "res://assets/sprites/items/icons/"

const ICON_MAP := {
	# Armas
	"item_w_001": "ITEM_W_001_galho_de_vigilia_64x64.png",
	"item_w_002": "ITEM_W_002_arco_de_folha_tensa_64x64.png",
	"item_w_003": "ITEM_W_003_presa_do_javali_de_musgo_64x64.png",
	"item_w_004": "ITEM_W_004_lamina_da_raposa_oca_64x64.png",
	"item_w_005": "ITEM_W_005_agulha_da_viuva_64x64.png",
	"item_w_006": "cajado_de_lumen.png",
	# Secundários / Escudos
	"item_s_001": "ITEM_S_001_broquel_de_casca_64x64.png",
	"item_s_002": "ITEM_S_002_lanterna_de_esporos_64x64.png",
	"item_s_003": "ITEM_S_003_totem_da_raiz_antiga_64x64.png",
	"item_s_004": "ITEM_S_004_farol_prismatico_64x64.png",
	"item_s_005": "ITEM_S_005_engrenagem_impossivel_64x64.png",
	"item_s_006": "ITEM_W_002_arco_de_folha_tensa_64x64.png",
	"item_s_007": "ITEM_S_002_lanterna_de_esporos_64x64.png",
	# Armaduras
	"item_a_001": "ITEM_A_001_manto_de_folhas_64x64.png",
	"item_a_002": "ITEM_A_002_couraca_de_musgo_64x64.png",
	"item_a_003": "ITEM_A_003_casco_cristalino_64x64.png",
	"item_a_004": "ITEM_A_004_coracao_de_pedra_64x64.png",
	"item_a_005": "ITEM_A_005_casca_do_guardiao_64x64.png",
	# Relíquias e Acessórios
	"item_r_001": "ITEM_R_001_gota_de_lumen_64x64.png",
	"item_r_002": "ITEM_R_002_esporo_sonolento_64x64.png",
	"item_r_003": "ITEM_R_003_talisma_do_salto_de_lumen_64x64.png",
	"item_r_004": "ITEM_R_004_olho_de_vidro_verde_64x64.png",
	"item_r_005": "ITEM_R_005_fragmento_prismatico_64x64.png",
	"item_r_006": "ITEM_R_006_dente_da_raposa_oca_64x64.png",
	"item_r_007": "ITEM_R_007_flor_de_musgo_64x64.png",
	"item_r_008": "ITEM_R_008_petala_do_primeiro_jardim_64x64.png",
	"item_r_009": "ITEM_R_009_raiz_faminta_64x64.png",
	"item_r_010": "ITEM_R_010_cinza_eterna_64x64.png",
	# Ecos
	"item_e_001": "ITEM_E_001_eco_da_geleia_64x64.png",
	"item_e_002": "ITEM_E_002_eco_da_mariposa_64x64.png",
	"item_e_003": "ITEM_E_003_eco_do_espinheiro_64x64.png",
	"item_e_004": "ITEM_E_004_sino_partido_64x64.png",
	"item_e_005": "ITEM_E_005_memoria_do_guardiao_64x64.png",
	"echo_c1_001": "ITEM_E_005_memoria_do_guardiao_64x64.png"
}

static var _cache: Dictionary = {}

static func get_texture(item_id: String) -> Texture2D:
	var clean_id := item_id.to_lower()
	if _cache.has(clean_id):
		return _cache[clean_id]
	var filename: String = ICON_MAP.get(clean_id, "")
	var tex: Texture2D = null
	if filename != "":
		var full_path := ICONS_64_DIR + filename if filename.contains("64x64") else ICONS_32_DIR + filename
		if ResourceLoader.exists(full_path):
			tex = load(full_path)
	if tex == null:
		# Tenta fallback por design_id se for uppercase
		var fallback_path := ICONS_64_DIR + item_id + "_64x64.png"
		if ResourceLoader.exists(fallback_path):
			tex = load(fallback_path)
	_cache[clean_id] = tex
	return tex

static func create_icon_rect(item_id: String, size: Vector2 = Vector2(48, 48)) -> TextureRect:
	var rect := TextureRect.new()
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = size
	rect.texture = get_texture(item_id)
	return rect

static func rarity_color(rarity: String) -> Color:
	match rarity.to_lower():
		"incomum":
			return Color(0.28, 0.78, 0.45) # Verde esmeralda
		"raro":
			return Color(0.2, 0.45, 0.86)   # Azul safira
		"épico", "epico":
			return Color(0.61, 0.32, 0.88) # Púrpura místico
		"lendário", "lendario":
			return Color(1.0, 0.67, 0.0)   # Dourado âmbar
		_:
			return Color(0.7, 0.7, 0.72)   # Cinza pedra neutro
