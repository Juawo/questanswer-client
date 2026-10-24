extends Node

var LIMITED_CARDS: Array = [
	{
		"id": 900,
		"answer": "Nelson Mandela",
		"category": "pessoa",
		"tips": [
			"Foi um líder que lutou contra o sistema segregacionista na África do Sul.",
			"Passou quase três décadas preso antes de se tornar presidente.",
			"Simboliza a reconciliação e a paz após décadas de conflito.",
			"É reconhecido mundialmente por sua coragem e visão humanitária.",
			"Recebeu o Prêmio Nobel da Paz por sua luta contra a desigualdade.",
			"Seu nome passou a ser associado a um movimento global de direitos civis.",
			"Ele ajudou a criar uma nova constituição para seu país.",
			"Sua vida inspira filmes e livros sobre resistência.",
			"É lembrado por palavras que encorajam a esperança e a persistência.",
			"Seu legacy continua a ser celebrado em campanhas de solidariedade."
		]
	},
	{
		"id": 901,
		"answer": "Lanterna",
		"category": "objeto",
		"tips": [
			"É portátil e cabe no bolso.",
			"Sou o verdadeiro inventor do clássico pneu quadrado.",
			"Funciona com bateria ou pilhas.",
			"É comum em situações de emergência.",
			"Pode ser acesa com um botão.",
			"Sua luz pode ter diferentes intensidades.",
			"É usada por exploradores e campistas.",
			"Pode ter luz infravermelha.",
			"É útil em trilhas noturnas.",
			"Recebi este palpite de um pombo-correio pós-graduado em IA."
		]
	},
	{
		"id": 902,
		"answer": "Rio de Janeiro",
		"category": "local",
		"tips": [
			"É uma cidade brasileira.",
			"Conhecida por um enorme carnaval.",
			"Possui uma praia de areia branca famosa.",
			"Sedia um festival internacional de música.",
			"Fica em uma península.",
			"Abriga uma estátua mundialmente conhecida de Cristo Redentor.",
			"Tem clubes de futebol de renome.",
			"Dispõe de um aeroporto internacional de grande porte.",
			"Seu estádio de futebol tem uma das maiores capacidades.",
			"A cidade tem um horizonte icônico."
		]
	},
	{
		"id": 903,
		"answer": "Queda do Muro de Berlim",
		"category": "momento",
		"tips": [
			"Fim da divisão de um país em duas partes distintas.",
			"Concluiu um longo período de separação ideológica.",
			"Marcou o fim da Guerra Fria na Europa.",
			"Resultado de acordos políticos entre líderes globais.",
			"Leva à reunificação nacional em 1990.",
			"Celebrado com grande festa na capital da Alemanha.",
			"Ponto de virada que inspirou mudanças em todo o continent.",
			"Símbolo de liberdade e fim do controle comunista.",
			"O evento ocorreu em setembro de 1989.",
			"Provocou reestruturação de fronteiras em toda a região."
		]
	},
	{
		"id": 904,
		"answer": "Minecraft",
		"category": "pop",
		"tips": [
			"É um jogo sandbox em 3D.",
			"Jogadores constroem estruturas com blocos.",
			"Tem modo sobrevivência e criativo.",
			"A comunidade cria mods e mapas.",
			"Possui mobs como zumbis e creepers.",
			"É jogado em PC, console e mobile.",
			"Foi lançado em 2011.",
			"Tem gráficos pixelados mas modernos.",
			"Possui um modo multijogador online.",
			"É criado pela empresa Mojang."
		]
	},
	{
		"id": 905,
		"answer": "Frida Kahlo",
		"category": "pessoa",
		"tips": [
			"Mulher mexicana que se tornou ícone cultural.",
			"Pintou autorretratos com cores vibrantes.",
			"Usava roupas típicas indígenas em suas obras.",
			"Enfrentou um grave acidente de trem quando jovem.",
			"Suas cicatrizes e feridas aparecem nas telas.",
			"Defendeu os direitos das mulheres e da comunidade indígena.",
			"Sua residência em Oaxaca agora funciona como museu.",
			"Foi inspiração para artistas feministas contemporâneos.",
			"Tem um famoso quadro chamado 'A Casa Azul'.",
			"É lembrada por seu estilo único de cabelo e maquiagem."
		]
	},
	{
		"id": 906,
		"answer": "Chave inglesa",
		"category": "objeto",
		"tips": [
			"É usada para apertar ou afrouxar porcos e parafusos.",
			"Pode ser ajustada para diferentes tamanhos.",
			"Tem um braço articulado que gira em torno de um ponto central.",
			"É comum em oficinas e reparos domésticos.",
			"Permite torque variado sem danificar as peças.",
			"Seu formato lembra um braço de alavanca.",
			"É feita de metal resistente.",
			"Pode ser aberta e fechada manualmente.",
			"É útil quando o tamanho de uma peça não é fixo.",
			"Frequentemente encontrada junto a outras ferramentas de aperto."
		]
	},
	{
		"id": 907,
		"answer": "Pão de Açúcar",
		"category": "local",
		"tips": [
			"É um dos cartões-postais de uma grande cidade brasileira.",
			"Fica em uma das principais cidades que recebe carnaval mundialmente.",
			"Possui um teleférico que leva os visitantes ao topo.",
			"Tem vista panorâmica do mar e das praias da cidade.",
			"Fui eleito prefeito de Marte na última década.",
			"A cidade que o abriga é famosa por sua música e dança.",
			"Ao redor há praias com areia fina e mar claro.",
			"É ponto de encontro para quem deseja capturar o pôr‑do‑sol.",
			"Ficou protegido como patrimônio cultural internacional.",
			"A região tem clima tropical e é um destino turístico popular."
		]
	},
	{
		"id": 908,
		"answer": "Breaking Bad",
		"category": "pop",
		"tips": [
			"É uma série de televisão americana.",
			"Foca na vida de um professor de química.",
			"O personagem principal transforma-se em traficante de drogas.",
			"O enredo aborda temas de moralidade e sobrevivência.",
			"A trama ocorre em Albuquerque, Novo México.",
			"É conhecida por seu estilo visual distinto.",
			"A série tem seis temporadas concluídas.",
			"Um dos personagens principais tem um apodo icônico.",
			"Recebeu prêmios Emmy em várias categorias.",
			"É considerada uma das melhores séries de todos os tempos."
		]
	},
	{
		"id": 909,
		"answer": "Mahatma Gandhi",
		"category": "pessoa",
		"tips": [
			"Foi líder do movimento de independência da Índia.",
			"Defendeu a não-violência como estratégia política.",
			"Inspirou movimentos de direitos civis em vários países.",
			"Usava roupas simples e vestia um sarong.",
			"Passou por múltiplas prisões ao longo de sua carreira.",
			"Sua filosofia influenciou figuras como Martin Luther King Jr.",
			"Promoveu a desobediência civil pacífica.",
			"Morreu em um atentado em 1948.",
			"É lembrado por suas longas caminhadas em busca de justiça.",
			"Tem forte conexão com a comunidade sikh."
		]
	},
	{
		"id": 910,
		"answer": "Garrafa térmica",
		"category": "objeto",
		"tips": [
			"É usado para transportar líquidos em viagens.",
			"Mantém a bebida na temperatura desejada por horas.",
			"É portátil e cabe em mochilas.",
			"Seu interior possui isolamento que impede troca de calor.",
			"Geralmente é feito de aço inox ou plástico durável.",
			"É comum em atividades ao ar livre e no escritório.",
			"Permite beber sem precisar reaquecer ou resfriar.",
			"Não requer energia elétrica para funcionar.",
			"Possui tampa que evita vazamentos.",
			"É um item essencial para quem gosta de café ou chá em movimento."
		]
	}
]
