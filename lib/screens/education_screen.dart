import 'package:flutter/material.dart';

// Constantes de Cores
const Color _primaryColor = Color(0xFF8C9EFF); // Lilás/Lavanda
const Color _cardBackground = Color(0xFFF5F5F5); // Cinza claro para cards

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  final List<Map<String, dynamic>> _sections = const [
    {
      'title': 'Entendendo Sua Condição',
      'subtitle': 'O que é osteoartrite e como ela afeta você',
      'icon': Icons.info_outline,
      'color': Color(0xFF64B5F6), // Azul
      'route': 'understanding',
    },
    {
      'title': 'Reconhecendo os Sinais',
      'subtitle': 'Sintomas principais e quando procurar ajuda',
      'icon': Icons.visibility_outlined,
      'color': Color(0xFFFFB74D), // Laranja
      'route': 'symptoms',
    },
    {
      'title': 'Por Que Acontece?',
      'subtitle': 'Causas e fatores que você pode controlar',
      'icon': Icons.help_outline,
      'color': Color(0xFF9575CD), // Roxo
      'route': 'causes',
    },
    {
      'title': 'Opções de Tratamento',
      'subtitle': 'Medicamentos, PICs e abordagem integrada',
      'icon': Icons.medical_services_outlined,
      'color': Color(0xFF4DB6AC), // Verde-azulado
      'route': 'treatment',
    },
    {
      'title': 'Comendo Para Aliviar',
      'subtitle': 'Alimentos amigos e o que evitar',
      'icon': Icons.restaurant_outlined,
      'color': Color(0xFFE57373), // Vermelho claro
      'route': 'nutrition',
    },
    {
      'title': 'Adaptações Práticas',
      'subtitle': 'Dicas para o dia a dia e proteção articular',
      'icon': Icons.home_outlined,
      'color': Color(0xFF81C784), // Verde
      'route': 'adaptations',
    },
    {
      'title': 'Cuidando da Mente',
      'subtitle': 'Bem-estar emocional e qualidade de vida',
      'icon': Icons.psychology_outlined,
      'color': Color(0xFFBA68C8), // Rosa-roxo
      'route': 'mental_health',
    },
    {
      'title': 'Sinais de Alerta',
      'subtitle': 'Quando procurar ajuda médica urgente',
      'icon': Icons.warning_amber_outlined,
      'color': Color(0xFFFF8A65), // Coral
      'route': 'alerts',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Educação',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Cabeçalho
          const Text(
            'Entenda a Osteoartrite',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Conhecimento é poder! Aprenda sobre sua condição e como viver melhor.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Lista de seções educativas
          ..._sections.map((section) => _buildEducationCard(
                context,
                title: section['title'] as String,
                subtitle: section['subtitle'] as String,
                icon: section['icon'] as IconData,
                color: section['color'] as Color,
                route: section['route'] as String,
              )),
        ],
      ),
    );
  }

  Widget _buildEducationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EducationDetailScreen(
                title: title,
                route: route,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Ícone com fundo colorido
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Ícone de seta
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela de Detalhes da Educação
class EducationDetailScreen extends StatelessWidget {
  final String title;
  final String route;

  const EducationDetailScreen({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final content = _getContentForRoute(route);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content.map((section) {
            if (section['type'] == 'title') {
              return Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                child: Text(
                  section['text'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              );
            } else if (section['type'] == 'subtitle') {
              return Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  section['text'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _primaryColor,
                  ),
                ),
              );
            } else if (section['type'] == 'text') {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  section['text'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              );
            } else if (section['type'] == 'bullet') {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: Text(
                        section['text'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (section['type'] == 'alert') {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE57373),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFE57373),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        section['text'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (section['type'] == 'tip') {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF81C784),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF66BB6A),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        section['text'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }

  List<Map<String, String>> _getContentForRoute(String route) {
    switch (route) {
      case 'understanding':
        return [
          {'type': 'subtitle', 'text': 'O que acontece?'},
          {
            'type': 'text',
            'text':
                'A osteoartrite (ou artrose) é o desgaste natural da cartilagem que protege suas articulações. Com o tempo, os ossos ficam mais próximos e causam dor e rigidez.'
          },
          {
            'type': 'text',
            'text':
                'Pense assim: É como o desgaste de um pneu de carro - com o uso ao longo dos anos, a proteção vai diminuindo.'
          },
          {'type': 'subtitle', 'text': 'Importante Saber:'},
          {'type': 'bullet', 'text': 'É muito comum após os 60 anos'},
          {'type': 'bullet', 'text': 'NÃO é culpa sua'},
          {'type': 'bullet', 'text': 'Tem tratamento e controle'},
          {'type': 'bullet', 'text': 'Você pode viver bem com osteoartrite'},
          {'type': 'subtitle', 'text': 'Articulações mais afetadas:'},
          {'type': 'bullet', 'text': 'Joelhos'},
          {'type': 'bullet', 'text': 'Mãos e dedos'},
          {'type': 'bullet', 'text': 'Quadril'},
          {'type': 'bullet', 'text': 'Coluna'},
          {'type': 'bullet', 'text': 'Pés'},
        ];
      case 'symptoms':
        return [
          {'type': 'subtitle', 'text': 'Sintomas principais:'},
          {'type': 'bullet', 'text': 'Dor nas articulações (piora com movimento)'},
          {'type': 'bullet', 'text': 'Rigidez pela manhã (melhora em 30 min)'},
          {'type': 'bullet', 'text': 'Inchaço leve nas juntas'},
          {'type': 'bullet', 'text': 'Estalos ao movimentar'},
          {'type': 'bullet', 'text': 'Dificuldade para realizar tarefas simples'},
          {'type': 'bullet', 'text': 'Sensação de "travamento"'},
          {'type': 'subtitle', 'text': 'Padrão comum:'},
          {'type': 'bullet', 'text': 'Manhã: mais rígido'},
          {'type': 'bullet', 'text': 'Tarde: melhora com movimento suave'},
          {'type': 'bullet', 'text': 'Noite: pode doer após atividades'},
          {
            'type': 'tip',
            'text': 'A dor varia: Alguns dias melhor, outros pior - é normal!'
          },
          {'type': 'subtitle', 'text': 'Quando procurar ajuda urgente:'},
          {'type': 'alert', 'text': 'Dor muito forte e súbita'},
          {'type': 'alert', 'text': 'Inchaço grande e vermelhidão'},
          {'type': 'alert', 'text': 'Febre junto com dor'},
          {'type': 'alert', 'text': 'Impossibilidade de mover a articulação'},
        ];
      case 'nutrition':
        return [
          {'type': 'subtitle', 'text': 'Alimentos AMIGOS (anti-inflamatórios):'},
          {'type': 'bullet', 'text': '🐟 Peixes (salmão, sardinha) - ômega 3'},
          {'type': 'bullet', 'text': '🫒 Azeite de oliva extra virgem'},
          {'type': 'bullet', 'text': '🥬 Vegetais verde-escuros'},
          {'type': 'bullet', 'text': '🫐 Frutas vermelhas'},
          {'type': 'bullet', 'text': '🧄 Alho e cebola'},
          {'type': 'bullet', 'text': '🫚 Gengibre e cúrcuma'},
          {'type': 'bullet', 'text': '🌰 Castanhas e nozes'},
          {'type': 'bullet', 'text': '🍊 Frutas cítricas (vitamina C)'},
          {'type': 'subtitle', 'text': 'Alimentos a EVITAR ou REDUZIR:'},
          {'type': 'bullet', 'text': '❌ Açúcar em excesso'},
          {'type': 'bullet', 'text': '❌ Frituras'},
          {'type': 'bullet', 'text': '❌ Carnes processadas'},
          {'type': 'bullet', 'text': '❌ Bebidas alcoólicas em excesso'},
          {'type': 'bullet', 'text': '❌ Sal em excesso'},
          {'type': 'subtitle', 'text': 'Hidratação e Chás:'},
          {'type': 'tip', 'text': '💧 Beba 6-8 copos de água por dia. A cartilagem precisa de água!'},
          {'type': 'bullet', 'text': '🍵 Chá verde'},
          {'type': 'bullet', 'text': '🫚 Gengibre'},
          {'type': 'bullet', 'text': '✨ Cúrcuma'},
          {'type': 'bullet', 'text': '🌿 Cavalinha'},
          {'type': 'alert', 'text': 'Sempre consulte seu médico antes de mudanças grandes na dieta'},
        ];
      case 'causes':
        return [
          {'type': 'subtitle', 'text': 'Por que acontece?'},
          {
            'type': 'text',
            'text':
                'A osteoartrite tem várias causas. Algumas você não controla (como idade e genética), outras você PODE controlar (como peso e nível de atividade).'
          },
          {'type': 'subtitle', 'text': 'Causas principais:'},
          {'type': 'bullet', 'text': 'Idade: desgaste natural ao longo da vida.'},
          {'type': 'bullet', 'text': 'Uso repetitivo: trabalhos ou atividades que sobrecarregam as articulações.'},
          {'type': 'bullet', 'text': 'Lesões anteriores: fraturas, torções ou traumas prévios.'},
          {'type': 'bullet', 'text': 'Sobrepeso: pressão extra sobre joelhos, quadris e coluna.'},
          {'type': 'bullet', 'text': 'Genética: tendência familiar em desenvolver artrose.'},
          {'type': 'bullet', 'text': 'Postura inadequada ao longo dos anos.'},
          {'type': 'subtitle', 'text': 'Fatores que você pode controlar:'},
          {'type': 'bullet', 'text': 'Peso corporal (com apoio profissional, se necessário).'},
          {'type': 'bullet', 'text': 'Atividade física regular e adaptada à sua condição.'},
          {'type': 'bullet', 'text': 'Postura no dia a dia (sentar, levantar, carregar peso).'},
          {'type': 'bullet', 'text': 'Proteção das articulações em tarefas domésticas e no trabalho.'},
          {'type': 'bullet', 'text': 'Alimentação equilibrada e anti-inflamatória.'},
        ];
      case 'treatment':
        return [
          {'type': 'subtitle', 'text': 'Objetivo do tratamento'},
          {
            'type': 'text',
            'text':
                'O foco do tratamento é reduzir a dor, melhorar o movimento e preservar sua independência nas atividades diárias.'
          },
          {'type': 'subtitle', 'text': 'Opções de tratamento:'},
          {'type': 'bullet', 'text': 'Medicamentos: analgésicos, anti-inflamatórios, pomadas e géis (sempre com orientação médica).'},
          {'type': 'bullet', 'text': 'Práticas integrativas e complementares (PICs): exercícios adaptados, termoterapia, acupuntura, yoga, tai chi, massagem, fitoterapia.'},
          {'type': 'bullet', 'text': 'Fisioterapia: fortalecimento muscular, ganho de mobilidade, proteção articular.'},
          {'type': 'bullet', 'text': 'Mudanças no estilo de vida: perda de peso (quando necessário), alimentação, sono e manejo do estresse.'},
          {'type': 'bullet', 'text': 'Tratamentos avançados: infiltrações, viscossuplementação e, em alguns casos, cirurgia.'},
          {
            'type': 'tip',
            'text':
                'O melhor resultado costuma vir da combinação de estratégias — não de um único tratamento isolado.'
          },
        ];
      case 'adaptations':
        return [
          {'type': 'subtitle', 'text': 'Adaptações que facilitam o dia a dia'},
          {
            'type': 'text',
            'text':
                'Pequenas mudanças em casa e na rotina podem reduzir a dor, evitar quedas e preservar sua independência.'
          },
          {'type': 'subtitle', 'text': 'Na cozinha:'},
          {'type': 'bullet', 'text': 'Use utensílios com cabos grossos e antiderrapantes.'},
          {'type': 'bullet', 'text': 'Prefira abridores automáticos para potes e garrafas.'},
          {'type': 'bullet', 'text': 'Mantenha itens de uso diário na altura dos olhos, evitando agachar ou subir em bancos.'},
          {'type': 'subtitle', 'text': 'No banheiro:'},
          {'type': 'bullet', 'text': 'Instale barras de apoio no box e próximo ao vaso sanitário.'},
          {'type': 'bullet', 'text': 'Use tapete antiderrapante dentro e fora do box.'},
          {'type': 'bullet', 'text': 'Se necessário, use banco para sentar durante o banho.'},
          {'type': 'subtitle', 'text': 'No quarto:'},
          {'type': 'bullet', 'text': 'Prefira colchão firme (nem muito mole, nem muito duro).'},
          {'type': 'bullet', 'text': 'Mantenha uma luz de presença para evitar quedas à noite.'},
          {'type': 'subtitle', 'text': 'Calçados:'},
          {'type': 'bullet', 'text': 'Use solado antiderrapante e salto baixo (2–3 cm).'},
          {'type': 'bullet', 'text': 'Dê preferência a modelos com bom amortecimento e fechamento fácil (velcro, por exemplo).'},
          {'type': 'subtitle', 'text': 'Movimentação e proteção articular:'},
          {'type': 'bullet', 'text': 'Levante-se devagar, principalmente após ficar muito tempo sentado ou deitado.'},
          {'type': 'bullet', 'text': 'Evite permanecer muito tempo na mesma posição.'},
          {'type': 'bullet', 'text': 'Ao carregar peso, mantenha próximo ao corpo e use as duas mãos.'},
          {'type': 'bullet', 'text': 'Considere usar bengala ou andador, se indicado pelo profissional de saúde.'},
        ];
      case 'mental_health':
        return [
          {'type': 'subtitle', 'text': 'Cuidando da mente'},
          {
            'type': 'text',
            'text':
                'Conviver com dor crônica pode trazer sentimentos de frustração, medo do futuro, tristeza e ansiedade. Isso é compreensível — e você não está sozinha(o).'
          },
          {'type': 'subtitle', 'text': 'É normal sentir:'},
          {'type': 'bullet', 'text': 'Frustração com as limitações físicas.'},
          {'type': 'bullet', 'text': 'Medo de piorar ou de perder independência.'},
          {'type': 'bullet', 'text': 'Tristeza em dias de dor mais forte.'},
          {'type': 'bullet', 'text': 'Ansiedade em relação a exames e tratamentos.'},
          {'type': 'subtitle', 'text': 'Estratégias de enfrentamento:'},
          {'type': 'bullet', 'text': 'Foque no que você CONSEGUE fazer hoje, mesmo que pareça pouco.'},
          {'type': 'bullet', 'text': 'Celebre pequenas vitórias (uma caminhada a mais, uma noite com menos dor).'},
          {'type': 'bullet', 'text': 'Mantenha hobbies e atividades prazerosas, mesmo adaptadas.'},
          {'type': 'bullet', 'text': 'Peça ajuda quando precisar; apoio de família e amigos faz diferença.'},
          {'type': 'bullet', 'text': 'Participe de grupos de apoio, presenciais ou online.'},
          {'type': 'bullet', 'text': 'Pratique exercícios de respiração e relaxamento regularmente.'},
          {
            'type': 'tip',
            'text':
                'Busque ajuda profissional (psicólogo/psiquiatra) se notar tristeza constante, perda de interesse em tudo ou pensamentos muito negativos.'
          },
        ];
      case 'alerts':
        return [
          {'type': 'subtitle', 'text': 'Sinais de alerta — procure ajuda médica:'},
          {
            'type': 'alert',
            'text':
                'Dor que piora rapidamente, muito intensa e diferente da dor habitual.'
          },
          {
            'type': 'alert',
            'text':
                'Inchaço grande, vermelhidão e calor intenso em uma articulação.'
          },
          {
            'type': 'alert',
            'text':
                'Febre junto com dor articular, calafrios ou mal-estar geral.'
          },
          {
            'type': 'alert',
            'text':
                'Impossibilidade de apoiar o peso ou mover a articulação acometida.'
          },
          {
            'type': 'alert',
            'text':
                'Deformidade súbita em uma articulação ou após uma queda importante.'
          },
          {'type': 'subtitle', 'text': 'Consultas regulares são importantes:'},
          {'type': 'bullet', 'text': 'Permitem ajustar medicações e acompanhar a evolução.'},
          {'type': 'bullet', 'text': 'São momento para tirar dúvidas e discutir novas opções de tratamento.'},
          {'type': 'bullet', 'text': 'Leve anotações sobre sua dor, atividades e o que tem ajudado ou piorado.'},
        ];
      default:
        return [
          {'type': 'text', 'text': 'Conteúdo em desenvolvimento.'},
        ];
    }
  }
}