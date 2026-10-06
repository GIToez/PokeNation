WIKICHAT_GREETS = {
	"Bem-vindo ao Wiki Chat! Através deste canal você poderá obter informações sobre o PSoul. Antes de começar, você precisa informar qual o idioma que você vai utilizar neste diálogo. Suas opções são: 'Português' e 'English'.",
	"Welcome to the Wiki Chat! Through this channel you can get information about PSoul. Before you begin, you need to tell what language you will use at this dialog. Your options are: 'Português' and 'English'.",
	--"Bienvenido a la Wiki chat! A través de este canal se puede obtener información acerca de la PSoul. Antes de empezar, tiene que decirle qué idioma que va a utilizar este cuadro de diálogo. Sus opciones son: 'Português', 'English' y 'Español'."
}

WIKICHAT_NODES = {
    {
        keywords = {'português', 'portugues'},
        parameters = {
            text = "Escolha uma categoria para prosseguir: 'essencial', 'básico', 'intermediário' ou 'avançado'."
        },
        childs = {
            {
                keywords = {'essencial'},
                parameters = {
                    text = "Categoria essencial - Você pode visualizar um destes tópicos: 'mover itens', 'mover personagem', 'soltar pokemon', 'usar itens', 'atacar', 'utilizar golpes do pokemon', 'ordenar pokemon', 'recolher loot', 'capturar pokemon', 'centro pokemon', 'curar', 'pokedex', 'deposito', 'olhar o nome dos itens', 'hotkeys', 'lista vip', 'mensagem privada', 'trade', 'soul coins', 'premium account' e 'girar pokemon'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
                    {
                        keywords = {'mover itens', 'mover item', 'mover iten'},
                        parameters = {
                            text = "Para movimentar os itens basta manter pressionado o botão esquerdo do mouse em cima do item e mover para onde você desejar. Note que o seu inventário é uma mochila, então para guardar um item no seu inventário mova o item para a mochila. Itens com a característica 'Unique' não podem ser jogados fora."
                        }
                    },
                    {
                        keywords = {'mover personagem', 'andar'},
                        parameters = {
                            text = "Para se mover basta clicar com o botão direito do mouse a onde você deseja ir, ou usar as setas direcionais do seu teclado."
                        }
                    },
                    {
                        keywords = {'soltar pokemon'},
                        parameters = {
                            text = "Para soltar o Pokemon você deve clicar no ícone 'Pokes' com o botão direito, com isso ira abrir uma aba de troca rápida onde só é preciso clicar em cima do ícone do Pokemon para solta-lo ou trocar."
                        }
                    },
                    {
                        keywords = {'usar itens', 'usar item', 'usar iten'},
                        parameters = {
                            text = "Para usar os itens clique com o botão direito do mouse em cima do item, alguns itens vão gerar uma mira, onde você deve escolher onde será usado, como por exemplo poções de cura."
                        }
                    },
                    {
                        keywords = {'atacar'},
                        parameters = {
                            text = "Para atacar um Pokemon você pode clicar com o botão esquerdo do mouse em cima do nome dele na aba Battle, ou clicar com o botão direito do mouse em cima do Pokemon na tela do jogo."
                        }
                    },
                    {
                        keywords = {'utilizar golpes do pokemon', 'golpe pokemon', 'utilizar golpe do pokemon'},
                        parameters = {
                            text = "Basta dizer m1 para o ataque 1, m2 para o ataque 2, m3 para o ataque 3 e assim por diante. Ou usar os atalhos, F1, F2, F3... Para editar os atalhos basta apertar Ctrl + K."
                        }
                    },
                    {
                        keywords = {'ordenar pokemon'},
                        parameters = {
                            text = "Solte o Pokemon, clique no botão 'Order' e clique onde você quer que o Pokemon vá. Para voar, nadar, ou montar em cima dele, solte o Pokemon com a respectiva habilidade e utilize o 'Order' em cima do seu personagem."
                        }
                    },
                    {
                        keywords = {'recolher loot', 'loot'},
                        parameters = {
                            text = "Basta clicar com o botão direito do mouse em cima do corpo do Pokemon derrotado e mover os itens, ou deixar ativado o comando /autoloot e clicar no corpo do Pokemon."
                        }
                    },
                    {
                        keywords = {'capturar pokemon', 'capturar'},
                        parameters = {
                            text = "Clique com o botão direito em cima de uma Pokebola vazia e clique com o botão esquerdo em cima do corpo do Pokemon derrotado, se a Pokebola ficar vermelha significa que não capturou, caso ficar verde significa que o Pokemon foi capturado. Note que caso você tenha 6 Pokemons no inventário o Pokemon capturado será levado ao Centro Pokemon."
                        }
                    },
                    {
                        keywords = {'centro pokemon'},
                        parameters = {
                            text = "O Centro Pokemon é onde você pode curar seus Pokemons e guardar seus itens."
                        }
                    },
                    {
                        keywords = {'curar', 'recuperar'},
                        parameters = {
                            text = {
							"Vá ao Centro Pokemon de diga 'hi' para a Nurse Joy, todos os seu Pokemons que estiver com você serão curados e você também.",
							"Caso você esteja no meio de uma caçada use as poções compradas na loja. As poções somente irão curar a vida, para reviver o Pokemon use o 'revive'."
							}
                        }
                    },
                    {
                        keywords = {'pokedex', 'dex'},
                        parameters = {
                            text = "Clique com o botão direito em cima da 'dex' e clique com o botão direito em cima do Pokemon. Para rever a dex, use a 'dex' em cima de você. Note que as informações dos Pokemons da segunda geração não serão salvas, a não ser que você atualize a sua pokedex."
                        }
                    },
                    {
                        keywords = {'deposito', 'depósito'},
                        parameters = {
                            text = "No centro Pokemon há um lugar onde você pode guardar os seus itens, clique com o botão direito em cima da máquina e guarde seus itens e Pokemons. Note que os Pokemons capturados serão depositados nessa máquina."
                        }
                    },
                    {
                        keywords = {'olhar o nome dos itens', 'nome item', 'nome itens'},
                        parameters = {
                            text = "Segure Shift e clique com o botão esquerdo no item, ou clique com o botão esquerdo e direito ao mesmo tempo em cima do item."
                        }
                    },
                    {
                        keywords = {'hotkeys', 'hotkey', 'atalho'},
                        parameters = {
                            text = {
								"Aperte Ctrl + K.",
								"Send automatically: utiliza automaticamente o atalho caso o mesmo seja de texto;",
								"Add: adiciona um item ao atalho selecionado;",
								"Remove: remove o item do atalho;",
								"Use on yourself: usa o item selecionado em você mesmo ao utilizar o atalho;",
								"Use on target: usa o item no alvo selecionado ao utilizar o atalho;",
								"With crosshair: abre a mira para você usar onde desejar."
							}
                        }
                    },
                    {
                        keywords = {'lista vip'},
                        parameters = {
                            text = "Clique com o segure Ctrl e clique com o botão direito em cima de um jogador e selecione a opção 'Add to Vip List'. Para ver a sua lista de amigos, clique na em VIP próximo do inventário."
                        }
                    },
                    {
                        keywords = {'mensagem privada'},
                        parameters = {
                            text = "Para mandar mensagem privada segure Ctrl e clique com o botão direito em cima de um jogador e selecione a opção 'Message to <nome do jogador>'."
                        }
                    },
                    {
                        keywords = {'trade'},
                        parameters = {
                            text = "Segure Ctrl e clique com o botão direito em cima do item na qual deseja trocar e selecione a opção 'Trade With...' e clique com o botão esquerdo em cima do jogador na qual você quer trocar. Após isso verifique se a troca será feita com o item que você deseja e clique em 'OK'."
                        }
                    },
                    {
                        keywords = {'soul coins', 'soul coin'},
                        parameters = {
                            text = "Soul Coins funcionam como uma espécie de moeda especial. Com elas você pode comprar premmium account, dar nome aos seus Pokemons, criar uma guild, comprar um regenerador de stamina, retirar Soul Coins da conta (withdraw) e checar quantidade de Soul Coins na conta (balance)."
                        }
                    },
                    {
                        keywords = {'premium account', 'vip'},
                        parameters = {
                            text = "Premium Account é uma forma de recompensa por doar dinheiro ao servidor, o servidor necessita de dinheiro para se manter se operante. As vantagens é que você pode usar todas as habilidades dos Pokemons, criar uma Guild, comprar uma casa, usar o Daycare, entre outros."
                        }
                    },
                    {
                        keywords = {'girar pokemon'},
                        parameters = {
                            text = "Use o atalho t1 para girar o pokemon para o norte, t2 para girar para leste, t3 para o sul, e t4 para oeste."
                        }
                    },
                },
			},
			{			
				keywords = {'básico', 'basico'},
                parameters = {
                    text = "Categoria básico - Você pode visualizar um destes tópicos: 'trocar roupa', 'pescar', 'viajar', 'evoluir', 'duelar contra npc', 'missões', 'banco', 'habilidades especiais', 'descrição dos golpes', 'shinys', 'corda', 'pokemart', 'poções', 'field remover', 'equipamentos', 'habilidades dos pokemons', 'surf', 'dive', 'ride', 'teleport', 'fly', 'dig', 'transform', 'cut', 'rock smash', 'flash', 'find', 'headbutt', 'marcar o mapa', 'berrys', 'pokemon perfect', 'egg' e 'pokemon market'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'trocar roupa'},
                        parameters = {
                            text = "Segure Ctrl e clique com o botão direito em cima do seu personagem e escolha a opção 'Set Outfit'."
                        }
                    },
					{
                        keywords = {'pescar'},
                        parameters = {
                            text = "Clique com o botão direito na vara de pesca e clique na água. Não se move enquanto está pescando, pois a ação de pesca pode ser cancelada."
                        }
                    },
					{
                        keywords = {'viajar'},
                        parameters = {
                            text = "Em Vermilion existe o barco S. S. Anne, onde você pode ir para as Ilhas Laranja e para Cinnabar."
                        }
                    },
					{
                        keywords = {'evoluir'},
                        parameters = {
                            text = "Verifique na Pokedex se o seu Pokemon e você já possuem os requisitos, após isso clique em 'Evolve'."
                        }
                    },
					{
                        keywords = {'duelar contra npc'},
                        parameters = {
                            text = "Para duelar com um NPC você deve ter dinheiro para apostar com o NPC. Aproxime-se de um NPC de duelo e diga: hi, duel, yes."
                        }
                    },
					{
                        keywords = {'missões', 'missoes', 'missão', 'missao', 'quest'},
                        parameters = {
                            text = "Para averiguar se o NPC tem alguma missão, diga: hi, mission, ou hi, help."
                        }
                    },
					{
                        keywords = {'banco'},
                        parameters = {
                            text = "Em todas as cidades existe um banco, nele você pode depositar o seu dinheiro para pagar a sua casa. Os comandos para falar com o NPC são: deposit (depositar), whitdraw (sacar), balance (checar saldo)."
                        }
                    },
					{
                        keywords = {'habilidades especiais', 'habilidade especial'},
                        parameters = {
                            text = "São características dos Pokemons onde passivamente conceder alguma vantagem ao seu Pokemon."
                        }
                    },
					{
                        keywords = {'descrição dos golpes', 'descriçao dos golpes', 'descricao dos golpes'},
                        parameters = {
                            text = "Segure o Shift e clique com o botão esquerdo em cima do ícone do golpe para ver a descrição do mesmo."
                        }
                    },
					{
                        keywords = {'shinys', 'shiny'},
                        parameters = {
                            text = "Os Pokemons shinys tem colorações exclusivas, 10% a mais de vida e 100 de energia a mais do que os Pokemons comuns."
                        }
                    },
					{
                        keywords = {'corda'},
                        parameters = {
                            text = "Ao descer em um buraco você vai precisar de uma corda para subir. Utilize a corda com o botão direito e clique com o botão esquerdo em cima de um círculo mais claro no chão."
                        }
                    },
					{
                        keywords = {'pokemart'},
                        parameters = {
                            text = "O PokeMart é uma loja onde você pode comprar e vender seus itens, sendo a sua opção para abastecer suas poções e Pokebolas. Todas as cidades possuem uma loja PokeMart, para iniciar a negociação diga: hi e depois trade."
                        }
                    },
					{
                        keywords = {'poções', 'poçoes', 'pocoes', 'poção', 'poçao', 'pocao'},
                        parameters = {
                            text = "Itens adquiridos através do PokeMart são utilizados para curar o Pokemon ou o seu personagem. Note que apenas a poção de cura +1 pode ser usada em personagens."
                        }
                    },
					{
                        keywords = {'field remover'},
                        parameters = {
                            text = "É usado para remover efeitos que ocorrem no solo resultantes dos ataques dos Pokemon, fire fields, rock fields, energy field, para que seja possível que você recolha o loot do Pokemon abatido ou até mesmo recuperar algum item do chão."
                        }
                    },
					{
                        keywords = {'equipamentos', 'equipamento'},
                        parameters = {
                            text = "Os equipamentos servem para lhe auxiliar no jogo, existem vários tipos tais como: lanternas, tênis, máscara de oxigênio e bicicleta."
                        }
                    },
					{
                        keywords = {'habilidades dos pokemons', 'habilidade do pokemon'},
                        parameters = {
                            text = "As habilidades servem para ajudar você em sua jornada. As habilidades que não necessitam Premium Account são: Ride, Dig, Transform, Cut, Rock Smash, Flash, Find, Headbutting. As que necessitam de Premium Account são: Teleport, Surf, Dive, Fly e Levitate."
                        }
                    },
					{
                        keywords = {'surf'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para nadar. Chegue perto da água solte o Pokemon com a habilidade e de 'order' em cima da borda. Para retornar a terra de 'order' em cima da borda."
                        }
                    },
					{
                        keywords = {'dive'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para mergulhar, em algumas áreas do mar existem redemoinhos que servem para ir a uma nova área de Pokemons aquáticos. Para entrar você necessita de uma oxygen mask, que pode ser adquirida em um NPC em Fuchsia, após ter a máscara de mergulho basta equipar na parte do equipamento e passar por cima do redemoinho, para voltar basta passar em cima das bolhas próximo a onde você desceu."
                        }
                    },
					{
                        keywords = {'ride'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para montar em cima do Pokemon. Solte o Pokemon com a habilidade e de 'order' em cima de você mesmo. Para voltar de 'order' em cima de você novamente."
                        }
                    },
					{
                        keywords = {'teleport'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para teletransportar-se para uma cidade. Para utilizar solte o Pokemon com a habilidade e diga: /teleport e escolha a cidade a onde deseja ir."
                        }
                    },
					{
                        keywords = {'fly'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para voar. Para utilizar solte o Pokemon com a habilidade e de 'order' em cima de você. Para subir diga: /up e para descer diga: /down. Para descer do Pokemon de 'order' em cima de você."
                        }
                    },
					{
                        keywords = {'dig'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para abrir buracos. Solte o Pokemon com a habilidade e de 'order' em cima de um monte de pedras pequenas para que possa abrir o buraco."
                        }
                    },
					{
                        keywords = {'transform'},
                        parameters = {
                            text = "Não requer Premium Account. É a habilidade de se transformar de Pokemons como o Ditto. Solte o Pokemon e de 'order' no Pokemon na qual você deseja copiar. A transformação tem duração de 30 minutos. Note que se você recolher o Pokemon ele vai perder a transformação."
                        }
                    },
					{
                        keywords = {'cut'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para cortar grama que impede passagem. Solte o Pokemon com a habilidade e de 'order' em cima de um amontoado de matos para cortar. Note que após certo tempo o mato volta a crescer."
                        }
                    },
					{
                        keywords = {'rock smash'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para quebrar pedras que estão impedindo a passagem. Solte o Pokemon com a habilidade e de 'order' em cima de uma pedra redonda e lisa para quebra-la. Note que após um tempo a pedra volta a aparecer."
                        }
                    },
					{
                        keywords = {'flash'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para clarear o ambiente escuro. Solte o Pokemon com a habilidade e de 'order' em cima do Pokemon. Para cancelar o efeito de 'order' em cima do Pokemon novamente."
                        }
                    },
					{
                        keywords = {'find'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para localizar algum jogador. Solte um Pokemon com a habilidade e diga: /find <nome do jogador> e com isso você vai receber uma mensagem dizendo o ponto cardeal (norte, leste, sul e oeste) em que o jogador está. Note que esta habilidade consome 15 de energia do Pokemon."
                        }
                    },
					{
                        keywords = {'headbutt'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para derrubar Pokemons selvagens das arvores. Solte o Pokemon com essa habilidade, e de 'order' em cima de uma árvore de cor mais clara e com alguns olhos. Dependendo da sua habilidade pode vir diversos Pokemons diferentes, após um período curto de tempo a arvore volta ao normal."
                        }
                    },
					{
                        keywords = {'marcar o mapa', 'marcar mapa'},
                        parameters = {
                            text = "O mapa ao canto superior direito pode ser marcado usando o clique direito do mouse sobre ele e escolhendo a opção única 'set mark' então você pode definir uma descrição do local desejado e também um ícone, facilitando assim sua localização no jogo."
                        }
                    },
					{
                        keywords = {'berrys', 'berry'},
                        parameters = {
                            text = "Berrys são frutas especiais que podem ser cultivadas em terrenos alugados ou em jardins existentes no quintal de algumas casas, você precisará de uma enxada, sementes e regadores, que podem ser comprados no NPC de Berrys de qualquer cidade. Os berrys tem efeitos especiais como regeneração 2000 pontos de HP, regeneração de 200 pontos de Energy, remoção do efeito burn, poison, sleep entre outros. Existe um intervalo de 15 minutos de intervalo entre o uso de um Berry e outro."
                        }
                    },
					{
                        keywords = {'pokemon perfect'},
                        parameters = {
                            text = "O Pokemon perfect é aquele no qual foi capturado no menor nível possível encontrado pelo mapa."
                        }
                    },
					{
                        keywords = {'egg'},
                        parameters = {
                            text = "No daycare é possível gerar ovos de Pokemons, basta colocar dois Pokemons do mesmo grupo e esperar 24 horas e remover o Pokemon femea. Note que o tipo do Pokemon femea é que decide que ovo vai ser, por exemplo, Charmander Femea + Squirtle Macho, se gerar um ovo, será um ovo de Charmander. Os Pokemons que nascem dos ovos vêm 1+10, e há uma pequena chance de virem shinys. É possível utilizar o Ditto como um coringa, mas a chance é reduzida. Não é possível gerar ovo de Pokemon de missão."
                        }
                    },
					{
                        keywords = {'pokemon market'},
                        parameters = {
                            text = {
							"É uma loja off-line, os jogadores podem deixar seus Pokemons para serem comprados por outros jogadores.",
							"A um Pokemon ser vendido ele é automaticamente transferido para o deposito do comprador e o jogador que vendeu irá receber uma carta confirmando a venda. Para receber o dinheiro da venda, o vendedor deve ir ao banco.",
							"Para vender, diga: hi, sell, <nome do Pokemon>, preço, yes.",
							"Para comprar, diga: hi, buy, <nome do Pokemon>, [aparece uma janela com as ofertas], <id da oferta desejada>, yes.",
							"Os shinys se diferenciam dos normais, ou seja para comprar um Shiny Arcanine, deve ser pesquisado por Shiny Arcanine, ou dizendo: buy, shiny, [aparece uma janela com as ofertas], <id da oferta desejada>, yes.",
							"Para ver as suas ofertas diga: list, [aparece uma janela com as ofertas]."
                        }
                    }
				}
            },
			},
			{
			keywords = {'intermediário', 'intermediario'},
                parameters = {
                    text = "Categoria intermediário - Você pode visualizar um destes tópicos: 'duelar contra um jogador', 'comprar uma casa', 'guild', 'guild house', 'torneio', 'zona saffari', 'apelidando pokemon' e 'tms'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'duelar contra um jogador', 'duelar'},
                        parameters = {
                            text = "Clique no item 'duel' e selecione o jogador à desafiar. Escolha a opção de quanto Pokemons serão usados no duelo, depois selecione quantos jogadores participarão do duelo e depois escolha se vai ser com ou sem aposta."
                        }
                    },
					{
                        keywords = {'comprar uma casa', 'comprar casa'},
                        parameters = {
                            text = "É necessário ao mínimo nível 50 e ser Premium Account. Verifique se a casa está vazia clicando com os dois botões do mouse em cima da porta para ver a descrição, caso a descrição seja: 'Nobody owns this house.' Significa que esta casa não tem dono. Para compra-la fique na frente da porta e digite '/house buy'. Todo mês você tem que pagar a casa, para paga-la basta deixar o dinheiro no banco ou no depósito do Centro Pokemon."
                        }
                    },
					{
                        keywords = {'guild'},
                        parameters = {
                            text = "Para criar uma Guild você precisa ao mínimo nível 50, ser Premium Account e ter 15 Soul Coins. Após ter todos os requisitos vá no NPC de Soul Coins e diga: hi, guild, <nome da guild>, yes. Para convidar alguem diga /invite <nome do jogador>, para aceitar diga !joinguild."
                        }
                    },
					{
                        keywords = {'guild house'},
                        parameters = {
                            text = "Somente o líder de uma Guild pode comprar uma Guild House. A Guild House não é uma casa, então o líder pode ter uma casa ao mesmo tempo. O comando para comprar é /house buy."
                        }
                    },
					{
                        keywords = {'torneio'},
                        parameters = {
                            text = "O torneio acontece diariamente, para se inscrever converse com o NPC Joey, localizado na área de trocas (PvP). Como recompensa por ganhar o torneio, você recebe um troféu, dinheiro (varia pela categoria), e uma moeda especial chamada Tournament Token."
                        }
                    },
					{
                        keywords = {'zona saffari', 'saffari'},
                        parameters = {
                            text = "É um lugar onde não se pode entrar com Pokemons e pokebolas. Lá dentro você utiliza as pedras em Pokemons agressivos, bolachas em Pokemons passivos, carne para distrair o Pokemon e armadilha para paralisa. O Saffari fica localizado em Fuchsia e custa 1000 doláres para entrar. Dica: leve potions +1 para curar seu personagem."
                        }
                    },
					{
                        keywords = {'apelidando pokemon'},
                        parameters = {
                            text = "Va ao NPC que negocie Soul Coins, coloque o Pokemon no slot para solta-lo e diga: hi, nick, <novo apelido>, yes. Essa opção custa 1 Soul Coin."
                        }
                    },
					{
                        keywords = {'tms', 'tm', 'technical machine'},
                        parameters = {
                            text = "São itens que concedem um novo golpe ao seu Pokemon ao custo de outro. Existe 3 categorias de TMs: Suporte, cura, e ofensivo. Só é possível ter uma TM de cada categoria e somente um move de cura para cada Pokemon. Existem 3 grupos de TM as iniciantes, intermediarias e avançadas com os respectivos níveis necessário para que o Pokemon aprenda o move: 20, 40 e 60."
                        }
                    }
				}
			},
			{
			keywords = {'avançado', 'avancado'},
                parameters = {
                    text = "Categoria avançado - Você pode visualizar um destes tópicos: 'mastery', 'blaze', 'avalanche', 'gaia', 'voltagic', 'hurricane', 'heremit', 'vital', 'spectrum', 'zen' e 'daycare'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'mastery'},
                        parameters = {
                            text = "É necessário estar com nível igual ou superior a 85 para entrar em uma mastery. A mastery lhe concede bônus de 20% a mais de ataque e defesa ao elemento da mesma, estando no ultimo rank. Além de uma vantagem exclusiva para cada mastery."
                        }
                    },
					{
                        keywords = {'blaze'},
                        parameters = {
                            text = "Fire: Status Burn com 100% a mais de dano. "
                        }
                    },
					{
                        keywords = {'avalanche'},
                        parameters = {
                            text = "Water/Ice: Velocidade extra no Surf e Dive; Todos os golpes do tipo Ice que infrigem dano com chance de deixar o oponente com o status Freeze."
                        }
                    },
					{
                        keywords = {'gaia'},
                        parameters = {
                            text = "Grass/Bug: Todos alimentos com regeneração de HP e Energy maiores."
                        }
                    },
					{
                        keywords = {'voltagic'},
                        parameters = {
                            text = "Electric/Steel: Maior regeneração de energia passiva (sem o uso de comida); Status Paralyze com 3 segundos a mais de duração."
                        }
                    },
					{
                        keywords = {'hurricane'},
                        parameters = {
                            text = "Flying/Dragon: Velocidade extra no Fly; Uso da habilidade Find sem custo de energia; Chance de evasão em moves (chance de escapar de algum golpe)."
                        }
                    },
					{
                        keywords = {'heremit'},
                        parameters = {
                            text = "Rock/Ground: Status Low Accuracy com 5 segundos a mais de duração."
                        }
                    },
					{
                        keywords = {'vital'},
                        parameters = {
                            text = "Normal/Fight: Velocidade extra no Ride; Moves que funcionam como buffs com 3 segundos a mais de duração."
                        }
                    },
					{
                        keywords = {'spectrum'},
                        parameters = {
                            text = "Poison/Ghost: Status Poison com 100% a mais de dano."
                        }
                    },
					{
                        keywords = {'zen'},
                        parameters = {
                            text = "Psychic/Dark: Menor intervalo no uso das habilidades Teleport e Blink."
                        }
                    },
					{
                        keywords = {'daycare'},
                        parameters = {
                            text = "É usado para dar experiência ao seu Pokémon. É necessário ser nível superior ou igual a 85 e ser Premium Account para utilizar. Ele fica localizado em Cerulean, a norte do Centro Pokemon. Para colocar um Pokemon no Daycare fale com o NPC Old Man para colocar Pokemons do sexo masculino ou assexuado e Old Lady para Pokemons do sexo ou assexuado. O Daycare também serve para gerar ovos de Pokemons."
                        }
                    }
				}
			}
        }
    },
	{
        keywords = {'english'},
        parameters = {
            text = "Select a category to continue: 'essential', 'basic', 'intermediate' or 'advanced'."
        },
        childs = {
            {
                keywords = {'essential'},
                parameters = {
                    text = "Essential category - You can view any of these topics: 'Move Items', 'move character', 'release pokemon', 'use items', 'attack', 'using pokemon moves', 'order pokemon', 'gather loot' 'catch pokemon', 'pokemon center', 'heal', 'pokedex', 'deposit', 'looking the name of the items',' hotkeys', 'VIP list', 'private message', 'trade', 'soul coins', 'premium account' and 'rotate pokemon'. Say 'back' at any time to return to the previous menu."
                },
                childs = {
					{
						keywords = {'back'},
						parameters = {
							moveup = 2,
						}
					},
                    {
                        keywords = {'move items', 'move item', 'move iten'},
                        parameters = {
                            text = "To move the items simply hold the left mouse button over the item and move it to where you want. Note that your inventory is a backpack, so to save an item in your inventory move the item to the backpack. Items with the characteristic 'Unique' can not be thrown away."
                        }
                    },
                    {
                        keywords = {'move character', 'walk'},
                        parameters = {
                            text = "To move just click with the right mouse button to where you want to go or use the arrow keys on your keyboard."
                        }
                    },
                    {
                        keywords = {'release pokemon'},
                        parameters = {
                            text = "To release the Pokemon you must click the 'Pokes' icon with the right button, it will open a tab for the fastchange where you need only click on the Pokemon icon to call it or fastchange."
                        }
                    },
                    {
                        keywords = {'use itens', 'use item', 'use iten'},
                        parameters = {
                            text = "Click to use items with the right mouse button on the item, some items will generate a crosshair which you must choose where it will be used, such as healing potions."
                        }
                    },
                    {
                        keywords = {'attack'},
                        parameters = {
                            text = "To attack a Pokemon you can click with the left mouse button over his name in Battle list or click the right mouse button over the Pokemon in the game screen."
                        }
                    },
                    {
                        keywords = {'using pokemon moves', 'using pokemon move'},
                        parameters = {
                            text = "Just say m1 for move 1, m2 for move 2, 3 for the move m3 and so on. Or use the shortcuts, F1, F2, F3 ... To edit the shortcuts simply press Ctrl + K."
                        }
                    },
                    {
                        keywords = {'order pokemon'},
                        parameters = {
                            text = "Release the Pokemon, click the 'Order' button and click where you want the Pokemon go. To fly, swim, or ride upon it, release the Pokemon with the ability and use the 'Order' upon your character."
                        }
                    },
                    {
                        keywords = {'gather loot', 'loot'},
                        parameters = {
                            text = "Just click with the right mouse button over the body of the defeated Pokemon and move the items to your backpack, or leave activated /autoloot command to automatic gather."
                        }
                    },
                    {
                        keywords = {'catch pokemon', 'catch'},
                        parameters = {
                            text = "Right click on an empty Pokeball and click the left mouse button on the body of the defeated Pokemon, Pokeball that turns red means that the catch fails. If turns green means that the Pokemon was caught. Note that if you have 6 Pokemon with you, the caught Pokemon will be taken to the Pokemon Center."
                        }
                    },
                    {
                        keywords = {'pokemon center'},
                        parameters = {
                            text = "The Pokemon Center is where you can heal your Pokemon and deposit your items."
                        }
                    },
                    {
                        keywords = {'heal'},
                        parameters = {
                            text = {
							"Go to the Pokemon Center say 'hi' to Nurse Joy, all your Pokemons that are with you and you will be healed.",
							"If you are in the middle of a adventure use the potions purchased from the Pokemart store. To revive the Pokemon use the 'Revive'."
							}
                        }
                    },
                    {
                        keywords = {'pokedex', 'dex'},
                        parameters = {
                            text = "Right click on the 'dex' and click right on top of Pokemon. To review the dex, use the 'dex' upon you. Note that the information of the second generation of Pokemon will not be saved unless you upgrade your pokedex."
                        }
                    },
                    {
                        keywords = {'deposit'},
                        parameters = {
                            text = "In Pokemon center there is a place where you can store your items, click the right button on the machine and store your items and Pokemon. Note that the caught Pokemon will be deposited on that machine."
                        }
                    },
                    {
                        keywords = {'looking the name of the items'},
                        parameters = {
                            text = "Hold Shift and click the left button on the item or click the left and right button while over the item."
                        }
                    },
                    {
                        keywords = {'hotkeys', 'hotkey'},
                        parameters = {
                            text = {
								"Press Ctrl + K.",
								"Send automatically: Automatically uses the shortcut if this is text;",
								"Add: adds a shortcut to the selected item;",
								"Remove: removes the item from the shortcut;",
								"Use on yourself: use the selected item in yourself when using the shortcut;",
								"Use on target: use the item in the selected target by using the shortcut;",
								"With crosshair: opens the crosshair to where you wish to use."
							}
                        }
                    },
                    {
                        keywords = {'vip list'},
                        parameters = {
                            text = "Hold Ctrl and click the right mouse button on a player and select 'Add to VIP List' option. To see your friends list, click on the VIP List next your inventory."
                        }
                    },
                    {
                        keywords = {'private message'},
                        parameters = {
                            text = "To send a private message hold Ctrl and click the right mouse button on a player and select 'Message to <username>' option."
                        }
                    },
                    {
                        keywords = {'trade'},
                        parameters = {
                            text = "Hold Ctrl and click the right mouse button on the item in which you want to change and select the 'Trade With ...' option and click the left mouse button on the player in which you want to exchange. After that make sure the exchange will be made with the item you want and click OK."
                        }
                    },
                    {
                        keywords = {'soul coins', 'soul coin'},
                        parameters = {
                            text = "Soul Coins function as a special kind of currency. With them you can buy premmium account, name your Pokemons, create a guild and buy a regenerating stamina."
                        }
                    },
                    {
                        keywords = {'premium account', 'vip'},
                        parameters = {
                            text = "Premium Account is a form of reward for donating to the server, the server needs money to keep it operating. The advantage is that you can use all the skills of Pokemons, create a guild, purchase a home, use the Daycare, among others."
                        }
                    },
                    {
                        keywords = {'rotate pokemon'},
                        parameters = {
                            text = "Use the shortcut to turn the pokemon t1 north, turn east to t2, t3 to the south and t4 to the west."
                        }
                    },
                },
			},
			{			
				keywords = {'basic'},
                parameters = {
                    text = "Basic Category - You can view any of these topics: 'change clothes', 'fish', 'travel', 'evolve', 'duel npc' , 'missions', 'bank', 'special abilities', 'move description', 'shinys', 'rope', 'pokemart', 'potions', 'field remover', 'equipment', 'pokemon abilities', 'surf', 'dive', 'ride', 'teleport', 'fly', 'dig', 'transform', 'cut', 'rock smash', 'flash', 'find', 'headbutt', 'mark map', 'berrys', 'perfect pokemon', 'egg' and 'pokemon market'. Say 'back' at any time to return to the previous menu."
                },
                childs = {
					{
						keywords = {'back'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'change clothes'},
                        parameters = {
                            text = "Hold Ctrl and click the right button on your character and choose 'Set Outfit' option."
                        }
                    },
					{
                        keywords = {'fish'},
                        parameters = {
                            text = "Right click on the fishing rod and click on water. Don't walk while fishing because the fishing action can be canceled."
                        }
                    },
					{
                        keywords = {'travel'},
                        parameters = {
                            text = "On Vermilion there is the boat SS Anne, where you can go to the Orange Arquipelago and Cinnabar."
                        }
                    },
					{
                        keywords = {'evolve'},
                        parameters = {
                            text = "Check your Pokedex and if you already have the requirements, click 'Evolve'."
                        }
                    },
					{
                        keywords = {'duel npc'},
                        parameters = {
                            text = "To duel with an NPC you must have money to bet with the NPC. Approach a duel NPC and say hi, duel, yes."
                        }
                    },
					{
                        keywords = {'missions', 'quest'},
                        parameters = {
                            text = "To investigate whether the NPC has a mission, say hi, mission, or hi, help."
                        }
                    },
					{
                        keywords = {'bank'},
                        parameters = {
                            text = "In every city there is a bank, there you can deposit your money to pay your house rent."
                        }
                    },
					{
                        keywords = {'special abilities'},
                        parameters = {
                            text = "Special Abilities are characteristics of which passively confers some advantage to your Pokemon."
                        }
                    },
					{
                        keywords = {'move description'},
                        parameters = {
                            text = "Hold the Shift key and click the left button on top of the move icon to see the description."
                        }
                    },
					{
                        keywords = {'shinys', 'shiny'},
                        parameters = {
                            text = "Pokemon shinys have exclusive colors, 10% more life and 100 more energy than common Pokemon."
                        }
                    },
					{
                        keywords = {'rope'},
                        parameters = {
                            text = "When descending into a hole you'll need a rope to climb. Use the rope with the right button and click the left button on top of a lighter circle on the floor."
                        }
                    },
					{
                        keywords = {'pokemart'},
                        parameters = {
                            text = "The Pokemart is a store where you can buy and sell your items. Also is your option to buy potions and pokeballs. All cities have a Pokemart shop. To start trading say hi and then trade."
                        }
                    },
					{
                        keywords = {'potions'},
                        parameters = {
                            text = "Items purchased through the Pokemart are used to heal your Pokemon or character. Note that only the healing potion +1 can be used in characters."
                        }
                    },
					{
                        keywords = {'field remover'},
                        parameters = {
                            text = "It is used to remove effects that occur in the soil resulting from the attacks of Pokemon. So it is possible you collect the loot from downed Pokemon or even retrieve some item from the ground."
                        }
                    },
					{
                        keywords = {'equipments'},
                        parameters = {
                            text = "Equipment intended to assist you in the game, there are various types such as flashlights, tennis, cycling and oxygen mask."
                        }
                    },
					{
                        keywords = {'pokemon abilities', 'pokemon ability'},
                        parameters = {
                            text = "The abilities are designed to help you on your journey. Abilities that do not require premium account are: Ride, Dig, Transform, Cut, Rock Smash, Flash, Find and Headbutting. Those that require premium account are: Teleport, Surf, Dive, Fly and Levitate."
                        }
                    },
					{
                        keywords = {'surf'},
                        parameters = {
                            text = "Requires Premium Account. Used for swimming. Go near the water release the Pokemon with the ability and 'order' over the border. To return to the land use 'order' over the border."
                        }
                    },
					{
                        keywords = {'dive'},
                        parameters = {
                            text = "Requires Premium Account. Used to dive in the sea there are some areas that serve swirls to go to a new area of water Pokemon. To enter you need an oxygen mask, which can be purchased at an NPC in Fuchsia, just equip the piece of equipment and go over swirl to return just pass upon bubbles close to where you down."
                        }
                    },
					{
                        keywords = {'ride'},
                        parameters = {
                            text = "It not requires Premium Account. Used to mount on top of the Pokemon. Release the Pokemon with the ability and 'order' upon yourself. To return to 'order' upon you again."
                        }
                    },
					{
                        keywords = {'teleport'},
                        parameters = {
                            text = "Requires Premium Account. Used to teleport to a city. To release use the Pokemon with the ability and say: /teleport and select the city you want to go."
                        }
                    },
					{
                        keywords = {'fly'},
                        parameters = {
                            text = "Requires Premium Account. Used to fly. To release use the Pokemon with the ability and 'order' upon you. To climb say /up and down to say /down. To dismount the Pokemon 'order' upon you."
                        }
                    },
					{
                        keywords = {'dig'},
                        parameters = {
                            text = "It not requires Premium Account. Used to open holes. Release the Pokemon with the ability and 'order' on top of a lot of small stones so you can open the hole."
                        }
                    },
					{
                        keywords = {'transform'},
                        parameters = {
                            text = "It not requires Premium Account. It is the ability to transform from Pokemon like Ditto. Release the Pokemon and 'order' in the Pokemon you want to copy. The transformation lasts 30 minutes."
                        }
                    },
					{
                        keywords = {'cut'},
                        parameters = {
                            text = "It not requires Premium Account. Used to cut grass that prevents passage. Release the Pokemon with the ability and 'order' upon a clump of bushes to cut. Note that after a while the forest grows back."
                        }
                    },
					{
                        keywords = {'rock smash'},
                        parameters = {
                            text = "It not requires Premium Account. Used to break stones that are blocking the passage. Release the Pokemon with the ability and 'order' on top of a round and smooth stone to break it. Note that after a while the stone reappears."
                        }
                    },
					{
                        keywords = {'flash'},
                        parameters = {
                            text = "It not requires Premium Account. Used to lighten the dark environment. Release the Pokemon with the ability and 'order' upon Pokemon. To cancel the effect of 'order' over the Pokemon again."
                        }
                    },
					{
                        keywords = {'find'},
                        parameters = {
                            text = "It not requires Premium Account. Used to find a player. Drop a Pokemon with the ability and say /find <username> and with that you will get a message saying the cardinal direction (north, east, south and west) where the player is. Note that this skill consumes 15 energy of Pokemon."
                        }
                    },
					{
                        keywords = {'headbutt'},
                        parameters = {
                            text = "It not requires Premium Account. Used to take down the trees wild Pokemons. Release the Pokemon with this ability, and 'order' upon a tree lighter in color and with some eyes. Depending on your skill can come many different Pokemons, after a short time the tree back to normal."
                        }
                    },
					{
                        keywords = {'mark map'},
                        parameters = {
                            text = "The map to the upper right corner can be marked using the right mouse click on it and select the one 'set mark' option so you can set a description of the desired location and also an icon, thus facilitating its location in the game."
                        }
                    },
					{
                        keywords = {'berrys', 'berry'},
                        parameters = {
                            text = "Berries are special fruits that can be grown on rented land or existing backyard gardens of some houses, you need a hoe, seeds and watering cans, which can be bought from Berries NPC of any city. The berries have special effects like HP regeneration 2000 points, 200 points regeneration of Energy, removal of burn effect, poison, sleep among others. There is an interval of 15 minutes between the use of one another and Berry."
                        }
                    },
					{
                        keywords = {'perfect pokemon'},
                        parameters = {
                            text = "The perfect Pokemon is the one that was captured in the lowest possible level found over the map."
                        }
                    },
					{
                        keywords = {'egg'},
                        parameters = {
                            text = "In daycare is possible to generate Pokemon eggs, just put two Pokemon of the same egggroup, wait 24 hours and remove the female Pokemon. Note that the type of Pokemon female egg is deciding what will be, for example, Charmander Female and Squirtle Male will generate a Charmander. Pokemon born from eggs come 1 +10, and there is a small chance of coming shinys. You can use Ditto as a wildcard, but the chance is reduced. It's not possible generate egg from quest Pokemon."
                        }
                    },
					{
                        keywords = {'pokemon market'},
                        parameters = {
                            text = {
							"It's an offline store, players can leave their Pokemons to be bought by other players.",
							"As a Pokemon be sold it is automatically transferred to the buyer's deposit and player sold will receive a letter confirming the sale. To receive money from the sale, the seller must go to the bank.",
							"To sell, say hi, sell, <Pokemon name>, price, yes.",
							"To buy, say hi, buy, <Pokemon name>, [a window appears with the offerings], <id>, yes.",
							"The shinys differ from normal, ie to buy a Shiny Arcanine should be researched by Shiny Arcanine, or saying buy, shiny, [a window appears with the offerings], <id>, yes.",
							"To see their offerings say: list, [a window appears with the offerings]."
                        }
                    }
				}
            },
			},
			{
			keywords = {'intermediate'},
                parameters = {
                    text = "Intermediate category - You can view any of these topics: 'duel against a player', 'buying a house', 'guild', 'guild house', 'tournament', 'saffari zone', 'nicknaming pokemon' and 'tms'. Say 'back' at any time to return to the previous menu."
                },
                childs = {
					{
						keywords = {'back'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'duel against a player'},
                        parameters = {
                            text = "Click the 'duel' item and select the player to challenge. Choose the option to be used as Pokemons in the duel, then select how many players participate in the duel and then choose whether to be or not to bet."
                        }
                    },
					{
                        keywords = {'buying a house'},
                        parameters = {
                            text = "You need to be minimum level 50 and Premium Account. Make sure the house is empty by clicking both mouse buttons above the door to see the description if the description is: 'Nobody owns this house.' Means that this house has no owner. To buy it is in front of the door and enter '/house buy'. Every month you have to pay for the house, to pays just leave the money in the bank or at the Pokemon Center deposit."
                        }
                    },
					{
                        keywords = {'guild'},
                        parameters = {
                            text = "To create a guild you need at least level 50, Premium Account and have to be 15 Soul Coins. After all requirements go in the Soul Coins NPC and say hi, guild, <name>, yes. To invite someone say /invite <username>, to accept say !joinguild."
                        }
                    },
					{
                        keywords = {'guild house'},
                        parameters = {
                            text = "Only the leader of a guild can buy a Guild House. The Guild House is not a home, then the leader can have a house at the same time. The command to buy is /buy house."
                        }
                    },
					{
                        keywords = {'tournament'},
                        parameters = {
                            text = "The tournament occurs every day, to sign up talk to the NPC Joey, located in the area of trade (PvP). As a reward for winning the tournament, you win a trophy, cash (varies by category) and a special currency called Tournament Token."
                        }
                    },
					{
                        keywords = {'saffari zone', 'saffari'},
                        parameters = {
                            text = "It is a place where you can not get with Pokemon and pokeballs. There you use small stones in aggressive Pokemon, cookies in passive Pokemon, meat to distract the Pokemon and trap's. The Saffari is located in Fuchsia and cost 1000 dollars to enter. Tip: +1 potions to heal your character."
                        }
                    },
					{
                        keywords = {'nicknaming pokemon'},
                        parameters = {
                            text = "Go to the NPC that negotiate Soul Coins, put the Pokemon in the slot to release him and say hi, nick, <nickname>, yes. This option costs 1 Soul Coin."
                        }
                    },
					{
                        keywords = {'tms', 'tm', 'technical machine'},
                        parameters = {
                            text = "TMs are items that grant a new move to your Pokemon at the cost of another. There are 3 categories of TMs: Support, healing, and offensive. Pokemon can only have a TM of each category and only one healing moves. There are 3 groups of the TM beginners, intermediate and advanced levels with their need for the Pokemon learn moves: 20, 40 and 60."
                        }
                    }
				}
			},
			{
			keywords = {'advanced'},
                parameters = {
                    text = "Advanced Category - You can view any of these topics: 'mastery', 'blaze', 'avalanche', 'gaia', 'voltagic', 'hurricane', 'heremit', 'vital', 'spectrum', 'zen' and 'daycare'. Say 'back' at any time to return to the previous menu."
                },
                childs = {
					{
						keywords = {'back'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'mastery'},
                        parameters = {
                            text = "Requires at least level 85 to join. The mastery bonus grants you 20% more attack and defense to the element of the same, being in the last rank. Besides a unique advantage for each mastery."
                        }
                    },
					{
                        keywords = {'blaze'},
                        parameters = {
                            text = "Fire: Status Burn 100% more damage."
                        }
                    },
					{
                        keywords = {'avalanche'},
                        parameters = {
                            text = "Water/Ice: Surf and Dive with extra speed; All Ice-type with chance to leave the opponent with the Freeze status."
                        }
                    },
					{
                        keywords = {'gaia'},
                        parameters = {
                            text = "Grass/Bug: All foods with higher HP and Energy regeneration."
                        }
                    },
					{
                        keywords = {'voltagic'},
                        parameters = {
                            text = "Electric/Steel: Increased regeneration of passive energy (without the use of food); Paralyse status with longer duration."
                        }
                    },
					{
                        keywords = {'hurricane'},
                        parameters = {
                            text = "Flying/Dragon: Fly with extra speed; Use of the Find skill no-cost energy; Chance of move evasion."
                        }
                    },
					{
                        keywords = {'heremit'},
                        parameters = {
                            text = "Rock/Ground: Status Low Accuracy with longer duration."
                        }
                    },
					{
                        keywords = {'vital'},
                        parameters = {
                            text = "Normal/Fight: Ride with extra speed; Moves that function as buffs with longer duration."
                        }
                    },
					{
                        keywords = {'spectrum'},
                        parameters = {
                            text = "Poison/Ghost: Poison status with 100% more damage."
                        }
                    },
					{
                        keywords = {'zen'},
                        parameters = {
                            text = "Psychic/Dark: Minor cooldown in the use of Teleport and Blink abilities."
                        }
                    },
					{
                        keywords = {'daycare'},
                        parameters = {
                            text = "It is used to give experience to your Pokémon. Requires at least level 85 and be Premium Account to use. It is located in Cerulean, north of the Pokemon Center. To put a Pokemon in the Daycare talk to the NPC Old Man for putting Pokemon male or sexless sex and the Old Lady to female or sexless Pokemon. The Daycare also serves to generate Pokemon eggs."
                        }
                    }
				}
			}
        }
    },
	--[[{
        keywords = {'español', 'espanol'},
        parameters = {
            text = "Selecciona una categoría para continuar: 'esencial', 'básico', 'intermedio' o 'avanzado'."
        },
        childs = {
            {
                keywords = {'esencial'},
                parameters = {
                    text = "Categoría esencial - Usted puede ver cualquiera de estos temas: 'Move Items carácter', 'movimiento', 'pokemon drop', 'artículos de uso "," ataque "," utilizando estafas pokemon', 'tipo Pokemon', 'recoger el botín' 'pokemon captura', 'centro pokemon', 'curar', 'Pokedex', 'depósito', 'buscando el nombre de los artículos', 'hotkeys', 'lista VIP', 'mensaje privado', 'comercio', 'monedas del alma ',' prima 'y' pokemon rotación '. Diga 'atrás' en cualquier momento para volver al menú anterior."
                },
                childs = {
					{
						keywords = {'atrás', 'atras'},
						parameters = {
							moveup = 2,
						}
					},
                    {
                        keywords = {'Move Items caracter'},
                        parameters = {
                            text = "Para mover los elementos, simplemente manteniendo pulsado el botón izquierdo del ratón sobre el elemento y moverlo a donde usted quiera. Tenga en cuenta que su inventario es una mochila, así que para guardar un elemento en su inventario mover el elemento a la bolsa. Los artículos con la característica 'Unique' no se pueden tirar."
                        }
                    },
                    {
                        keywords = {'movimiento'},
                        parameters = {
                            text = "Para desplazarse basta con hacer clic con el botón derecho del ratón a donde usted quiere ir, o utilice las teclas de flecha del teclado."
                        }
                    },
                    {
                        keywords = {'pokemon drop'},
                        parameters = {
                            text = "Para liberar el Pokemon debe hacer clic en el icono 'Atiza' con el botón derecho, se abrirá una ficha para el intercambio rápido donde usted necesita solamente haga clic en el icono de Pokemon perderlo o intercambio."
                        }
                    },
                    {
                        keywords = {'artículos de uso'},
                        parameters = {
                            text = "Haga clic para utilizar elementos con el botón derecho del ratón sobre el tema, algunos artículos generarán una cruz, lo que hay que elegir dónde se va a utilizar, como pociones curativas."
                        }
                    },
                    {
                        keywords = {'ataque'},
                        parameters = {
                            text = "Para atacar a un Pokémon puede hacer clic con el botón izquierdo del ratón sobre su nombre en la pestaña de batalla, o haga clic en el botón derecho del ratón sobre el Pokémon en la pantalla del juego."
                        }
                    },
                    {
                        keywords = {'utilizando estafas pokemon'},
                        parameters = {
                            text = "Sólo decir m1 para el ataque 1, m2 para el ataque 2, 3 m3 para el ataque y así sucesivamente. O utilizar los accesos directos, F1, F2, F3 ... Para editar los accesos directos sólo tiene que pulsar Ctrl + K."
                        }
                    },
                    {
                        keywords = {'tipo Pokemon'},
                        parameters = {
                            text = "Suelte el Pokemon, haga clic en el botón 'Ordenar' y haga clic donde desea que el Pokemon ir. Para volar, nadar, o andar en ella, suelte el Pokemon con su habilidad y utilizar el 'orden' en su carácter."
                        }
                    },
                    {
                        keywords = {'recoger el botín'},
                        parameters = {
                            text = "Basta con hacer clic con el botón derecho del ratón sobre el cuerpo de los Pokémon derrotado y mover elementos, o deje de comandos activado / autoloot y haga clic en el cuerpo de Pokemon."
                        }
                    },
                    {
                        keywords = {'pokemon captura'},
                        parameters = {
                            text = "Haga clic derecho sobre una Pokeball vacía y haga clic en el botón izquierdo del ratón sobre el cuerpo de los Pokémon derrotado, Pokeball para convertir el rojo significa no capturados si se pone en verde significa que el Pokemon fue capturado. Tenga en cuenta que si usted tiene 6 Pokemon en Pokemon captura se tomaría el inventario al Centro Pokemon."
                        }
                    },
                    {
                        keywords = {'centro pokemon'},
                        parameters = {
                            text = "O Centro Pokemon é onde você pode curar seus Pokemons e guardar seus itens."
                        }
                    },
                    {
                        keywords = {'curar', 'recuperar'},
                        parameters = {
                            text = {
							"Vá ao Centro Pokemon de diga 'hi' para a Nurse Joy, todos os seu Pokemons que estiver com você serão curados e você também.",
							"Caso você esteja no meio de uma caçada use as poções compradas na loja. As poções somente irão curar a vida, para reviver o Pokemon use o 'revive'."
							}
                        }
                    },
                    {
                        keywords = {'pokedex', 'dex'},
                        parameters = {
                            text = "Clique com o botão direito em cima da 'dex' e clique com o botão direito em cima do Pokemon. Para rever a dex, use a 'dex' em cima de você. Note que as informações dos Pokemons da segunda geração não serão salvas, a não ser que você atualize a sua pokedex."
                        }
                    },
                    {
                        keywords = {'deposito', 'depósito'},
                        parameters = {
                            text = "No centro Pokemon há um lugar onde você pode guardar os seus itens, clique com o botão direito em cima da máquina e guarde seus itens e Pokemons. Note que os Pokemons capturados serão depositados nessa máquina."
                        }
                    },
                    {
                        keywords = {'olhar o nome dos itens', 'nome item', 'nome itens'},
                        parameters = {
                            text = "Segure Shift e clique com o botão esquerdo no item, ou clique com o botão esquerdo e direito ao mesmo tempo em cima do item."
                        }
                    },
                    {
                        keywords = {'hotkeys', 'hotkey', 'atalho'},
                        parameters = {
                            text = {
								"Aperte Ctrl + K.",
								"Send automatically: utiliza automaticamente o atalho caso o mesmo seja de texto;",
								"Add: adiciona um item ao atalho selecionado;",
								"Remove: remove o item do atalho;",
								"Use on yourself: usa o item selecionado em você mesmo ao utilizar o atalho;",
								"Use on target: usa o item no alvo selecionado ao utilizar o atalho;",
								"With crosshair: abre a mira para você usar onde desejar."
							}
                        }
                    },
                    {
                        keywords = {'lista vip'},
                        parameters = {
                            text = "Clique com o segure Ctrl e clique com o botão direito em cima de um jogador e selecione a opção 'Add to Vip List'. Para ver a sua lista de amigos, clique na em VIP próximo do inventário."
                        }
                    },
                    {
                        keywords = {'mensagem privada'},
                        parameters = {
                            text = "Para mandar mensagem privada segure Ctrl e clique com o botão direito em cima de um jogador e selecione a opção 'Message to <nome do jogador>'."
                        }
                    },
                    {
                        keywords = {'trade'},
                        parameters = {
                            text = "Segure Ctrl e clique com o botão direito em cima do item na qual deseja trocar e selecione a opção 'Trade With...' e clique com o botão esquerdo em cima do jogador na qual você quer trocar. Após isso verifique se a troca será feita com o item que você deseja e clique em 'OK'."
                        }
                    },
                    {
                        keywords = {'soul coins', 'soul coin'},
                        parameters = {
                            text = "Soul Coins funcionam como uma espécie de moeda especial. Com elas você pode comprar premmium account, dar nome aos seus Pokemons, criar uma guild, comprar um regenerador de stamina, retirar Soul Coins da conta (withdraw) e checar quantidade de Soul Coins na conta (balance)."
                        }
                    },
                    {
                        keywords = {'premium account', 'vip'},
                        parameters = {
                            text = "Premium Account é uma forma de recompensa por doar dinheiro ao servidor, o servidor necessita de dinheiro para se manter se operante. As vantagens é que você pode usar todas as habilidades dos Pokemons, criar uma Guild, comprar uma casa, usar o Daycare, entre outros."
                        }
                    },
                    {
                        keywords = {'girar pokemon'},
                        parameters = {
                            text = "Use o atalho t1 para girar o pokemon para o norte, t2 para girar para leste, t3 para o sul, e t4 para oeste."
                        }
                    },
                },
			},
			{			
				keywords = {'básico'},
                parameters = {
                    text = "Categoria básico - Você pode visualizar um destes tópicos: 'trocar roupa', 'pescar', 'viajar', 'evoluir', 'duelar contra npc', 'missões', 'banco', 'habilidades especiais', 'descrição dos golpes', 'shinys', 'corda', 'pokemart', 'poções', 'field remover', 'equipamentos', 'habilidades dos pokemons', 'surf', 'dive', 'ride', 'teleport', 'fly', 'dig', 'transform', 'cut', 'rock smash', 'flash', 'find', 'headbutt', 'marcar o mapa', 'marcar o mapa', 'berrys', 'pokemon perfect', 'egg' e 'pokemon market'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'trocar roupa'},
                        parameters = {
                            text = "Segure Ctrl e clique com o botão direito em cima do seu personagem e escolha a opção 'Set Outfit'."
                        }
                    },
					{
                        keywords = {'pescar'},
                        parameters = {
                            text = "Clique com o botão direito na vara de pesca e clique na água. Não se move enquanto está pescando, pois a ação de pesca pode ser cancelada."
                        }
                    },
					{
                        keywords = {'viajar'},
                        parameters = {
                            text = "Em Vermilion existe o barco S. S. Anne, onde você pode ir para as Ilhas Laranja e para Cinnabar."
                        }
                    },
					{
                        keywords = {'evoluir'},
                        parameters = {
                            text = "Verifique na Pokedex se o seu Pokemon e você já possuem os requisitos, após isso clique em 'Evolve'."
                        }
                    },
					{
                        keywords = {'duelar contra npc'},
                        parameters = {
                            text = "Para duelar com um NPC você deve ter dinheiro para apostar com o NPC. Aproxime-se de um NPC de duelo e diga: hi, duel, yes."
                        }
                    },
					{
                        keywords = {'missões', 'missoes', 'missão', 'missao', 'quest'},
                        parameters = {
                            text = "Para averiguar se o NPC tem alguma missão, diga: hi, mission, ou hi, help."
                        }
                    },
					{
                        keywords = {'banco'},
                        parameters = {
                            text = "Em todas as cidades existe um banco, nele você pode depositar o seu dinheiro para pagar a sua casa. Os comandos para falar com o NPC são: deposit (depositar), whitdraw (sacar), balance (checar saldo)."
                        }
                    },
					{
                        keywords = {'habilidades especiais', 'habilidade especial'},
                        parameters = {
                            text = "São características dos Pokemons onde passivamente conceder alguma vantagem ao seu Pokemon."
                        }
                    },
					{
                        keywords = {'descrição dos golpes', 'descriçao dos golpes', 'descricao dos golpes'},
                        parameters = {
                            text = "Segure o Shift e clique com o botão esquerdo em cima do ícone do golpe para ver a descrição do mesmo."
                        }
                    },
					{
                        keywords = {'shinys', 'shiny'},
                        parameters = {
                            text = "Os Pokemons shinys tem colorações exclusivas, 10% a mais de vida e 100 de energia a mais do que os Pokemons comuns."
                        }
                    },
					{
                        keywords = {'corda'},
                        parameters = {
                            text = "Ao descer em um buraco você vai precisar de uma corda para subir. Utilize a corda com o botão direito e clique com o botão esquerdo em cima de um círculo mais claro no chão."
                        }
                    },
					{
                        keywords = {'pokemart'},
                        parameters = {
                            text = "O PokeMart é uma loja onde você pode comprar e vender seus itens, sendo a sua opção para abastecer suas poções e Pokebolas. Todas as cidades possuem uma loja PokeMart, para iniciar a negociação diga: hi e depois trade."
                        }
                    },
					{
                        keywords = {'poções', 'poçoes', 'pocoes', 'poção', 'poçao', 'pocao'},
                        parameters = {
                            text = "Itens adquiridos através do PokeMart são utilizados para curar o Pokemon ou o seu personagem. Note que apenas a poção de cura +1 pode ser usada em personagens."
                        }
                    },
					{
                        keywords = {'field remover'},
                        parameters = {
                            text = "É usado para remover efeitos que ocorrem no solo resultantes dos ataques dos Pokemon, fire fields, rock fields, energy field, para que seja possível que você recolha o loot do Pokemon abatido ou até mesmo recuperar algum item do chão."
                        }
                    },
					{
                        keywords = {'equipamentos', 'equipamento'},
                        parameters = {
                            text = "Os equipamentos servem para lhe auxiliar no jogo, existem vários tipos tais como: lanternas, tênis, máscara de oxigênio e bicicleta."
                        }
                    },
					{
                        keywords = {'habilidades dos pokemons', 'habilidade do pokemon'},
                        parameters = {
                            text = "As habilidades servem para ajudar você em sua jornada. As habilidades que não necessitam Premium Account são: Ride, Dig, Transform, Cut, Rock Smash, Flash, Find, Headbutting. As que necessitam de Premium Account são: Teleport, Surf, Dive, Fly e Levitate."
                        }
                    },
					{
                        keywords = {'surf'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para nadar. Chegue perto da água solte o Pokemon com a habilidade e de 'order' em cima da borda. Para retornar a terra de 'order' em cima da borda."
                        }
                    },
					{
                        keywords = {'dive'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para mergulhar, em algumas áreas do mar existem redemoinhos que servem para ir a uma nova área de Pokemons aquáticos. Para entrar você necessita de uma oxygen mask, que pode ser adquirida em um NPC em Fuchsia, após ter a máscara de mergulho basta equipar na parte do equipamento e passar por cima do redemoinho, para voltar basta passar em cima das bolhas próximo a onde você desceu."
                        }
                    },
					{
                        keywords = {'ride'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para montar em cima do Pokemon. Solte o Pokemon com a habilidade e de 'order' em cima de você mesmo. Para voltar de 'order' em cima de você novamente."
                        }
                    },
					{
                        keywords = {'teleport'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para teletransportar-se para uma cidade. Para utilizar solte o Pokemon com a habilidade e diga: /teleport e escolha a cidade a onde deseja ir."
                        }
                    },
					{
                        keywords = {'fly'},
                        parameters = {
                            text = "Requer Premium Account. Utilizada para voar. Para utilizar solte o Pokemon com a habilidade e de 'order' em cima de você. Para subir diga: /up e para descer diga: /down. Para descer do Pokemon de 'order' em cima de você."
                        }
                    },
					{
                        keywords = {'dig'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para abrir buracos. Solte o Pokemon com a habilidade e de 'order' em cima de um monte de pedras pequenas para que possa abrir o buraco."
                        }
                    },
					{
                        keywords = {'transform'},
                        parameters = {
                            text = "Não requer Premium Account. É a habilidade de se transformar de Pokemons como o Ditto. Solte o Pokemon e de 'order' no Pokemon na qual você deseja copiar. A transformação tem duração de 30 minutos. Note que se você recolher o Pokemon ele vai perder a transformação."
                        }
                    },
					{
                        keywords = {'cut'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para cortar grama que impede passagem. Solte o Pokemon com a habilidade e de 'order' em cima de um amontoado de matos para cortar. Note que após certo tempo o mato volta a crescer."
                        }
                    },
					{
                        keywords = {'rock smash'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para quebrar pedras que estão impedindo a passagem. Solte o Pokemon com a habilidade e de 'order' em cima de uma pedra redonda e lisa para quebra-la. Note que após um tempo a pedra volta a aparecer."
                        }
                    },
					{
                        keywords = {'flash'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para clarear o ambiente escuro. Solte o Pokemon com a habilidade e de 'order' em cima do Pokemon. Para cancelar o efeito de 'order' em cima do Pokemon novamente."
                        }
                    },
					{
                        keywords = {'find'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para localizar algum jogador. Solte um Pokemon com a habilidade e diga: /find <nome do jogador> e com isso você vai receber uma mensagem dizendo o ponto cardeal (norte, leste, sul e oeste) em que o jogador está. Note que esta habilidade consome 15 de energia do Pokemon."
                        }
                    },
					{
                        keywords = {'headbutt'},
                        parameters = {
                            text = "Não requer Premium Account. Utilizada para derrubar Pokemons selvagens das arvores. Solte o Pokemon com essa habilidade, e de 'order' em cima de uma árvore de cor mais clara e com alguns olhos. Dependendo da sua habilidade pode vir diversos Pokemons diferentes, após um período curto de tempo a arvore volta ao normal."
                        }
                    },
					{
                        keywords = {'marcar o mapa', 'marcar mapa'},
                        parameters = {
                            text = "O mapa ao canto superior direito pode ser marcado usando o clique direito do mouse sobre ele e escolhendo a opção única 'set mark' então você pode definir uma descrição do local desejado e também um ícone, facilitando assim sua localização no jogo."
                        }
                    },
					{
                        keywords = {'berrys', 'berry'},
                        parameters = {
                            text = "Berrys são frutas especiais que podem ser cultivadas em terrenos alugados ou em jardins existentes no quintal de algumas casas, você precisará de uma enxada, sementes e regadores, que podem ser comprados no NPC de Berrys de qualquer cidade. Os berrys tem efeitos especiais como regeneração 2000 pontos de HP, regeneração de 200 pontos de Energy, remoção do efeito burn, poison, sleep entre outros. Existe um intervalo de 15 minutos de intervalo entre o uso de um Berry e outro."
                        }
                    },
					{
                        keywords = {'pokemon perfectt'},
                        parameters = {
                            text = "O Pokemon perfect é aquele no qual foi capturado no menor nível possível encontrado pelo mapa."
                        }
                    },
					{
                        keywords = {'egg'},
                        parameters = {
                            text = "No daycare é possível gerar ovos de Pokemons, basta colocar dois Pokemons do mesmo grupo e esperar 24 horas e remover o Pokemon femea. Note que o tipo do Pokemon femea é que decide que ovo vai ser, por exemplo, Charmander Femea + Squirtle Macho, se gerar um ovo, será um ovo de Charmander. Os Pokemons que nascem dos ovos vêm 1+10, e há uma pequena chance de virem shinys. É possível utilizar o Ditto como um coringa, mas a chance é reduzida. Não é possível gerar ovo de Pokemon de missão."
                        }
                    },
					{
                        keywords = {'pokemon market'},
                        parameters = {
                            text = {
							"É uma loja off-line, os jogadores podem deixar seus Pokemons para serem comprados por outros jogadores.",
							"A um Pokemon ser vendido ele é automaticamente transferido para o deposito do comprador e o jogador que vendeu irá receber uma carta confirmando a venda. Para receber o dinheiro da venda, o vendedor deve ir ao banco.",
							"Para vender, diga: hi, sell, <nome do Pokemon>, preço, yes.",
							"Para comprar, diga: hi, buy, <nome do Pokemon>, [aparece uma janela com as ofertas], <id da oferta desejada>, yes.",
							"Os shinys se diferenciam dos normais, ou seja para comprar um Shiny Arcanine, deve ser pesquisado por Shiny Arcanine, ou dizendo: buy, shiny, [aparece uma janela com as ofertas], <id da oferta desejada>, yes.",
							"Para ver as suas ofertas diga: list, [aparece uma janela com as ofertas]."
                        }
                    }
				}
            },
			},
			{
			keywords = {'intermediário'},
                parameters = {
                    text = "Categoria intermediário - Você pode visualizar um destes tópicos: 'duelar contra um jogador', 'comprar uma casa', 'guild', 'guild house', 'torneio', 'zona saffari', 'apelidando pokemon' e 'tms'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'duelar contra um jogador', 'duelar'},
                        parameters = {
                            text = "Clique no item 'duel' e selecione o jogador à desafiar. Escolha a opção de quanto Pokemons serão usados no duelo, depois selecione quantos jogadores participarão do duelo e depois escolha se vai ser com ou sem aposta."
                        }
                    },
					{
                        keywords = {'comprar uma casa', 'comprar casa'},
                        parameters = {
                            text = "É necessário ao mínimo nível 50 e ser Premium Account. Verifique se a casa está vazia clicando com os dois botões do mouse em cima da porta para ver a descrição, caso a descrição seja: 'Nobody owns this house.' Significa que esta casa não tem dono. Para compra-la fique na frente da porta e digite '/house buy'. Todo mês você tem que pagar a casa, para paga-la basta deixar o dinheiro no banco ou no depósito do Centro Pokemon."
                        }
                    },
					{
                        keywords = {'guild'},
                        parameters = {
                            text = "Para criar uma Guild você precisa ao mínimo nível 50, ser Premium Account e ter 15 Soul Coins. Após ter todos os requisitos vá no NPC de Soul Coins e diga: hi, guild, <nome da guild>, yes. Para convidar alguem diga /invite <nome do jogador>, para aceitar diga !joinguild."
                        }
                    },
					{
                        keywords = {'guild house'},
                        parameters = {
                            text = "Somente o líder de uma Guild pode comprar uma Guild House. A Guild House não é uma casa, então o líder pode ter uma casa ao mesmo tempo. O comando para comprar é /house buy."
                        }
                    },
					{
                        keywords = {'torneio'},
                        parameters = {
                            text = "O torneio acontece diariamente, para se inscrever converse com o NPC Joey, localizado na área de trocas (PvP). Como recompensa por ganhar o torneio, você recebe um troféu, dinheiro (varia pela categoria), e uma moeda especial chamada Tournaments Tokens."
                        }
                    },
					{
                        keywords = {'zona saffari', 'saffari'},
                        parameters = {
                            text = "É um lugar onde não se pode entrar com Pokemons e pokebolas. Lá dentro você utiliza as pedras em Pokemons agressivos, bolachas em Pokemons passivos, carne para distrair o Pokemon e armadilha para paralisa. O Saffari fica localizado em Fuchsia e custa 1000 doláres para entrar. Dica: leve potions +1 para curar seu personagem."
                        }
                    },
					{
                        keywords = {'apelidando pokemon'},
                        parameters = {
                            text = "Va ao NPC que negocie Soul Coins, coloque o Pokemon no slot para solta-lo e diga: hi, nick, <novo apelido>, yes. Essa opção custa 1 Soul Coin."
                        }
                    },
					{
                        keywords = {'tms', 'tm', 'technical machine'},
                        parameters = {
                            text = "São itens que concedem um novo golpe ao seu Pokemon ao custo de outro. Existe 3 categorias de TMs: Suporte, cura, e ofensivo. Só é possível ter uma TM de cada categoria e somente um move de cura para cada Pokemon. Existem 3 grupos de TM as iniciantes, intermediarias e avançadas com os respectivos níveis necessário para que o Pokemon aprenda o move: 20, 40 e 60."
                        }
                    }
				}
			},
			{
			keywords = {'avançado'},
                parameters = {
                    text = "Categoria avançado - Você pode visualizar um destes tópicos: 'mastery', 'blaze', 'avalanche', 'gaia', 'voltagic', 'hurricane', 'heremit', 'vital', 'spectrum', 'zen' e 'daycare'. Diga 'voltar' a qualquer momento para retornar ao menu anterior."
                },
                childs = {
					{
						keywords = {'voltar'},
						parameters = {
							moveup = 2,
						}
					},
					{
                        keywords = {'mastery'},
                        parameters = {
                            text = "É necessário estar com nível igual ou superior a 85 para entrar em uma mastery. A mastery lhe concede bônus de 20% a mais de ataque e defesa ao elemento da mesma, estando no ultimo rank. Além de uma vantagem exclusiva para cada mastery."
                        }
                    },
					{
                        keywords = {'blaze'},
                        parameters = {
                            text = "Fire: Status Burn com 100% a mais de dano. "
                        }
                    },
					{
                        keywords = {'avalanche'},
                        parameters = {
                            text = "Water/Ice: Velocidade extra no Surf e Dive; Todos os golpes do tipo Ice que infrigem dano com chance de deixar o oponente com o status Freeze."
                        }
                    },
					{
                        keywords = {'gaia'},
                        parameters = {
                            text = "Grass/Bug: Todos alimentos com regeneração de HP e Energy maiores."
                        }
                    },
					{
                        keywords = {'voltagic'},
                        parameters = {
                            text = "Electric/Steel: Maior regeneração de energia passiva (sem o uso de comida); Status Paralyze com 3 segundos a mais de duração."
                        }
                    },
					{
                        keywords = {'hurricane'},
                        parameters = {
                            text = "Flying/Dragon: Velocidade extra no Fly; Uso da habilidade Find sem custo de energia; Chance de evasão em moves (chance de escapar de algum golpe)."
                        }
                    },
					{
                        keywords = {'heremit'},
                        parameters = {
                            text = "Rock/Ground: Status Low Accuracy com 5 segundos a mais de duração."
                        }
                    },
					{
                        keywords = {'vital'},
                        parameters = {
                            text = "Normal/Fight: Velocidade extra no Ride; Moves que funcionam como buffs com 3 segundos a mais de duração."
                        }
                    },
					{
                        keywords = {'spectrum'},
                        parameters = {
                            text = "Poison/Ghost: Status Poison com 100% a mais de dano."
                        }
                    },
					{
                        keywords = {'zen'},
                        parameters = {
                            text = "Psychic/Dark: Menor intervalo no uso das habilidades Teleport e Blink."
                        }
                    },
					{
                        keywords = {'daycare'},
                        parameters = {
                            text = "É usado para dar experiência ao seu Pokémon. É necessário ser nível superior ou igual a 85 e ser Premium Account para utilizar. Ele fica localizado em Cerulean, a norte do Centro Pokemon. Para colocar um Pokemon no Daycare fale com o NPC Old Man para colocar Pokemons do sexo masculino ou assexuado e Old Lady para Pokemons do sexo ou assexuado. O Daycare também serve para gerar ovos de Pokemons."
                        }
                    }
				}
			}
        }
    },]]
}