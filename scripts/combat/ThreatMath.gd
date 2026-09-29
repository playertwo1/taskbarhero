extends RefCounted
class_name ThreatMath

## Escolha de alvo por ameaça do v0.4 (THREAT_AGGRO_SYSTEM.md), função pura (SLICE-1A-4a).
## 1 de dano efetivo gera 1 de ameaça; o ×1,5 do Bastião é aplicado por quem chama.

const SWITCH_THRESHOLD := 1.15
## Seção 3: 1 cura efetiva = 0,5 de ameaça; 1 de escudo consumido = 0,5 para quem criou o escudo.
const HEAL_THREAT := 0.5
const SHIELD_THREAT := 0.5

## threat: id → ameaça; order: ids do front ao back; alive: id → vivo.
## forced: alvo de uma provocação ativa (vence a tabela, se estiver vivo).
## O alvo atual só troca se o melhor candidato superar a ameaça dele em 15%.
## Sem ameaça nenhuma, mantém o atual (se vivo) ou escolhe o primeiro vivo da ordem (front).
static func pick_target(threat: Dictionary, current: String, order: Array, alive: Dictionary, forced: String = "") -> String:
	if forced != "" and bool(alive.get(forced, false)):
		return forced
	var best := ""
	var best_value := -1.0
	for id in order:
		if bool(alive.get(id, false)):
			var value := float(threat.get(id, 0.0))
			if value > best_value:
				best = id
				best_value = value
	if best == "":
		return ""
	var current_alive: bool = current != "" and bool(alive.get(current, false))
	if best_value <= 0.0:
		return current if current_alive else best
	if current_alive and current != best and best_value <= float(threat.get(current, 0.0)) * SWITCH_THRESHOLD:
		return current
	return best
