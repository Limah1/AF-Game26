extends Node2D

var popup_text
var popup_title

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	popup_text = $Control/DorPopup/MarginContainer/HBoxContainer/VBoxContainer/text
	popup_title = $Control/DorPopup/MarginContainer/HBoxContainer/VBoxContainer/title
	
	$Control/DorPopup.popup_exclusive = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_nivel0_pressed():
	$Control/DorPopup.popup_centered()
	$Control/PopupBackground.visible = true
	
	popup_title.bbcode_text = "[center]Sem dor"
	popup_text.bbcode_text = 'Uhuu! Hoje você está super bem. Beba água ao longo do dia, brinque, caminhe um pouco, alongue o corpo e evite lugares muito frios ou com ar-condicionado gelado. Nada de exageros. Isso ajuda a prevenir novas'



func _on_nivel2_pressed():
	$Control/DorPopup.popup_centered()
	$Control/PopupBackground.visible = true
	
	popup_title.bbcode_text = "[center]Dor Leve"
	popup_text.bbcode_text = 'Hora de ir mais devagar. Sente-se ou deite um pouco, tome goles de água e faça respirações calmas (puxa pelo nariz contando 3, solta pela boca contando 3). Se estiver frio, fique quentinho. Uma compressa morna pode ajudar. Faça coisas tranquilas, como desenhar ou ouvir música, e veja se melhora.'



func _on_nivel4_pressed():
	$Control/DorPopup.popup_centered()
	$Control/PopupBackground.visible = true
	
	popup_title.bbcode_text = "[center]Dor tolerável"
	popup_text.bbcode_text = 'Pare a brincadeira e descanse num lugar calmo e quentinho. Continue bebendo água e use compressa morna por alguns minutos. Se o médico deixou um remédio para dor para usar em casa, peça a um adulto para dar do jeitinho da receita e espere um tempinho para ver se melhora.'



func _on_nivel6_pressed():
	$Control/DorPopup.popup_centered()
	$Control/PopupBackground.visible = true
	
	popup_title.bbcode_text = "[center]Muito Angustiante"
	popup_text.bbcode_text = 'Agora é cuidado redobrado. Fique em repouso, aquecido e bem hidratado. Use compressa morna. Se tiver remédio orientado pelo médico, tome com a ajuda de um adulto. Veja se há sinais de alerta: febre, falta de ar, dor no peito, vômitos repetidos, palidez forte. Se não melhorar, avise e procure o serviço de saúde.'
	

func _on_nivel8_pressed():
	$Control/DorPopup.popup_centered()
	$Control/PopupBackground.visible = true
	
	popup_title.bbcode_text = "[center]Muito Intensa"
	popup_text.bbcode_text = 'Chame um adulto já. Siga o plano de dor que o médico explicou (remédio na dose certa). Fique aquecido, beba pequenos goles de água e evite frio/ar-condicionado. Se a dor não melhorar rápido ou aparecer qualquer sinal de alerta, vá para a urgência.'



func _on_nivel10_pressed():
	$Control/DorPopup.popup_centered()
	$Control/PopupBackground.visible = true
	
	popup_title.bbcode_text = "[center]Excruciante Insuportável"
	popup_text.bbcode_text = 'É emergência. Avise o responsável e procure ajuda médica imediatamente (Samu 192 ou pronto-socorro). Enquanto isso, fique quentinho, respire devagar e beba pequenos goles de água se estiver bem. Na emergência, os profissionais vão cuidar da dor e da hidratação.'
	


func _on_novamente_pressed():
	$Control/DorPopup.hide()
	$Control/PopupBackground.visible = false
	
	pass # Replace with function body.


func _on_casa_pressed():
	pass # Replace with function body.
