import os
import sys

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

SCRIPT_TEMPLATE = """extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_dead: bool = false

func _ready() -> void:
	if anim_sprite:
		anim_sprite.animation_finished.connect(_on_animation_finished)
		anim_sprite.play("idle")

func play_idle() -> void:
	if is_dead:
		return
	if anim_sprite and anim_sprite.animation != "idle":
		anim_sprite.play("idle")

func play_attack() -> void:
	if is_dead:
		return
	if anim_sprite:
		anim_sprite.play("attack")

func play_hit() -> void:
	if is_dead:
		return
	if anim_sprite:
		anim_sprite.play("hit")

func play_death() -> void:
	is_dead = true
	if anim_sprite:
		anim_sprite.play("death")

func reset() -> void:
	is_dead = false
	if anim_sprite:
		anim_sprite.play("idle")

func _on_animation_finished() -> void:
	if not is_dead and anim_sprite and anim_sprite.animation != "idle":
		anim_sprite.play("idle")
"""

def generate_tscn(node_name, sheet_res, script_res, frame_size, offset_y, sf_id):
    w = frame_size
    h = frame_size
    
    # 16 frames: 4 idle, 4 attack, 2 hit, 6 death
    sub_resources = []
    
    # Idle 0..3
    for i in range(4):
        x = i * w
        sub_resources.append(f"""[sub_resource type="AtlasTexture" id="AtlasTexture_idle_{i}"]
atlas = ExtResource("1_sheet")
region = Rect2({x}, 0, {w}, {h})
""")
    
    # Attack 0..3
    for i in range(4):
        x = (4 + i) * w
        sub_resources.append(f"""[sub_resource type="AtlasTexture" id="AtlasTexture_attack_{i}"]
atlas = ExtResource("1_sheet")
region = Rect2({x}, 0, {w}, {h})
""")
        
    # Hit 0..1
    for i in range(2):
        x = (8 + i) * w
        sub_resources.append(f"""[sub_resource type="AtlasTexture" id="AtlasTexture_hit_{i}"]
atlas = ExtResource("1_sheet")
region = Rect2({x}, 0, {w}, {h})
""")

    # Death 0..5
    for i in range(6):
        x = (10 + i) * w
        sub_resources.append(f"""[sub_resource type="AtlasTexture" id="AtlasTexture_death_{i}"]
atlas = ExtResource("1_sheet")
region = Rect2({x}, 0, {w}, {h})
""")

    # SpriteFrames definition
    idle_frames = ", ".join([f"""{{\n"duration": 1.0,\n"texture": SubResource("AtlasTexture_idle_{i}")\n}}""" for i in range(4)])
    attack_frames = ", ".join([f"""{{\n"duration": 1.0,\n"texture": SubResource("AtlasTexture_attack_{i}")\n}}""" for i in range(4)])
    hit_frames = ", ".join([f"""{{\n"duration": 1.0,\n"texture": SubResource("AtlasTexture_hit_{i}")\n}}""" for i in range(2)])
    death_frames = ", ".join([f"""{{\n"duration": 1.0,\n"texture": SubResource("AtlasTexture_death_{i}")\n}}""" for i in range(6)])

    sprite_frames = f"""[sub_resource type="SpriteFrames" id="{sf_id}"]
animations = [{{
"frames": [{idle_frames}],
"loop": true,
"name": &"idle",
"speed": 6.0
}}, {{
"frames": [{attack_frames}],
"loop": false,
"name": &"attack",
"speed": 10.0
}}, {{
"frames": [{hit_frames}],
"loop": false,
"name": &"hit",
"speed": 12.0
}}, {{
"frames": [{death_frames}],
"loop": false,
"name": &"death",
"speed": 8.0
}}]"""

    content = f"""[gd_scene load_steps=21 format=3]

[ext_resource type="Texture2D" path="{sheet_res}" id="1_sheet"]
[ext_resource type="Script" path="{script_res}" id="2_script"]

{"".join(sub_resources)}
{sprite_frames}

[node name="{node_name}" type="Node2D"]
script = ExtResource("2_script")

[node name="AnimatedSprite2D" type="AnimatedSprite2D" parent="."]
texture_filter = 1
sprite_frames = SubResource("{sf_id}")
animation = &"idle"
autoplay = "idle"
centered = true
offset = Vector2(0, {offset_y})
"""
    return content

ENTITIES = [
    # 5 New Heroes
    {
        "type": "hero",
        "name": "Brasa",
        "tscn_path": "scenes/heroes/Brasa.tscn",
        "gd_path": "scenes/heroes/Brasa.gd",
        "sheet_res": "res://assets/sprites/heroes/brasa/hero_brasa_sheet.png",
        "script_res": "res://scenes/heroes/Brasa.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_brasa"
    },
    {
        "type": "hero",
        "name": "Veu",
        "tscn_path": "scenes/heroes/Veu.tscn",
        "gd_path": "scenes/heroes/Veu.gd",
        "sheet_res": "res://assets/sprites/heroes/veu/hero_veu_sheet.png",
        "script_res": "res://scenes/heroes/Veu.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_veu"
    },
    {
        "type": "hero",
        "name": "Orvalho",
        "tscn_path": "scenes/heroes/Orvalho.tscn",
        "gd_path": "scenes/heroes/Orvalho.gd",
        "sheet_res": "res://assets/sprites/heroes/orvalho/hero_orvalho_sheet.png",
        "script_res": "res://scenes/heroes/Orvalho.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_orvalho"
    },
    {
        "type": "hero",
        "name": "Forja",
        "tscn_path": "scenes/heroes/Forja.tscn",
        "gd_path": "scenes/heroes/Forja.gd",
        "sheet_res": "res://assets/sprites/heroes/forja/hero_forja_sheet.png",
        "script_res": "res://scenes/heroes/Forja.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_forja"
    },
    {
        "type": "hero",
        "name": "Sino",
        "tscn_path": "scenes/heroes/Sino.tscn",
        "gd_path": "scenes/heroes/Sino.gd",
        "sheet_res": "res://assets/sprites/heroes/sino/hero_sino_sheet.png",
        "script_res": "res://scenes/heroes/Sino.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_sino"
    },
    # 5 New Enemies
    {
        "type": "enemy",
        "name": "SaqueadorDaMata",
        "tscn_path": "scenes/enemies/SaqueadorDaMata.tscn",
        "gd_path": "scenes/enemies/SaqueadorDaMata.gd",
        "sheet_res": "res://assets/sprites/enemies/saqueador_da_mata/mob_saqueador_mata_sheet.png",
        "script_res": "res://scenes/enemies/SaqueadorDaMata.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_saqueador"
    },
    {
        "type": "enemy",
        "name": "XamaDeEsporos",
        "tscn_path": "scenes/enemies/XamaDeEsporos.tscn",
        "gd_path": "scenes/enemies/XamaDeEsporos.gd",
        "sheet_res": "res://assets/sprites/enemies/xama_de_esporos/mob_xama_esporos_sheet.png",
        "script_res": "res://scenes/enemies/XamaDeEsporos.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_xama"
    },
    {
        "type": "enemy",
        "name": "SentinelaDeRaizes",
        "tscn_path": "scenes/enemies/SentinelaDeRaizes.tscn",
        "gd_path": "scenes/enemies/SentinelaDeRaizes.gd",
        "sheet_res": "res://assets/sprites/enemies/sentinela_de_raizes/mob_sentinela_raizes_sheet.png",
        "script_res": "res://scenes/enemies/SentinelaDeRaizes.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_sentinela"
    },
    {
        "type": "enemy",
        "name": "LoboDeSombra",
        "tscn_path": "scenes/enemies/LoboDeSombra.tscn",
        "gd_path": "scenes/enemies/LoboDeSombra.gd",
        "sheet_res": "res://assets/sprites/enemies/lobo_de_sombra/mob_lobo_sombra_sheet.png",
        "script_res": "res://scenes/enemies/LoboDeSombra.gd",
        "frame_size": 48,
        "offset_y": -20,
        "sf_id": "SpriteFrames_lobo_sombra"
    },
    {
        "type": "enemy",
        "name": "MatriarcaDoMicelio",
        "tscn_path": "scenes/enemies/MatriarcaDoMicelio.tscn",
        "gd_path": "scenes/enemies/MatriarcaDoMicelio.gd",
        "sheet_res": "res://assets/sprites/bosses/matriarca_micelio/boss_matriarca_micelio_sheet.png",
        "script_res": "res://scenes/enemies/MatriarcaDoMicelio.gd",
        "frame_size": 64,
        "offset_y": -28,
        "sf_id": "SpriteFrames_matriarca"
    }
]

def main():
    for ent in ENTITIES:
        full_tscn = os.path.join(PROJECT_ROOT, ent["tscn_path"])
        full_gd = os.path.join(PROJECT_ROOT, ent["gd_path"])
        
        # Write .gd script
        with open(full_gd, "w", encoding="utf-8") as f:
            f.write(SCRIPT_TEMPLATE)
        print(f"Created script: {ent['gd_path']}")
        
        # Write .tscn file
        tscn_content = generate_tscn(
            ent["name"],
            ent["sheet_res"],
            ent["script_res"],
            ent["frame_size"],
            ent["offset_y"],
            ent["sf_id"]
        )
        with open(full_tscn, "w", encoding="utf-8") as f:
            f.write(tscn_content)
        print(f"Created scene: {ent['tscn_path']}")

if __name__ == "__main__":
    main()
