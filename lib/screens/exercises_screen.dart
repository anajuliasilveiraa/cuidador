// ignore_for_file: deprecated_member_use, unnecessary_brace_in_string_interps, unused_import, unused_element

import 'package:cuidador_app/screens/exercise_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/exercicio.dart';
import '../models/registro_exercicio.dart';
import 'diario_pos_screen.dart'; 

// Definições de Cores
const Color _primaryColor = Color(0xFF8C9EFF); // Lilás principal
const Color _secondaryColor = Color(0xFFF0F0F0); // Fundo suave/claro para o TabBar
const Color _progressDoneColor = Color(0xFFA6B1FF); // Lilás forte para o preenchimento do progresso
const Color _progressTotalColor = Color(0xFFE0E0E0); // Cinza suave para o fundo da barra de progresso
const Color _tertiaryColor = Color(0xFFFF7043); // Cor Laranja para "Ver todos" e Seta
const Color _appBarSolidColor = Color.fromARGB(255, 205, 209, 246);


class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final ApiService _apiService = ApiService();
  List<Exercicio> _exercicios = [];
  Set<int> _exerciciosConcluidosIds = {}; 
  List<RegistroExercicio> _historicoExercicios = [];
  bool _isLoading = true;
  String? _error;

  int _exercisesDone = 0;
  int _exercisesTotal = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token!;

      final List<dynamic> allExercisesData = await _apiService.getExercises(token);
      final List<Exercicio> todosExercicios =
          allExercisesData.map((e) => Exercicio.fromJson(e)).toList();

      // Histórico de exercícios para preencher a aba "Diário Pós"
      final List<dynamic> historyData =
          await _apiService.getExerciseHistory(token);
      final List<RegistroExercicio> historico =
          historyData.map((e) => RegistroExercicio.fromJson(e)).toList();

      setState(() {
        _exercicios = todosExercicios;
        _historicoExercicios = historico;

        // Considera como "feitos" os exercícios que possuem ao menos um registro no histórico
        _exerciciosConcluidosIds =
            historico.map((r) => r.exercicioId).toSet();

        _exercisesTotal = _exercicios.length;
        _exercisesDone = _exerciciosConcluidosIds.length;
        
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // --- WIDGETS DE LAYOUT CUSTOMIZADOS ---

  Widget _buildProgressCard() {
    double progressRatio = _exercisesTotal > 0 ? _exercisesDone / _exercisesTotal : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 70,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _progressTotalColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressRatio,
                child: Container(
                  decoration: BoxDecoration(
                    color: _progressDoneColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Row(
                  children: [
                    // 'Feitos'
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Feitos',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Valor Concluído (X)
                    Text(
                      '${_exercisesDone}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: progressRatio > 0.1 ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    // Total (Y)
                    Text(
                      '${_exercisesTotal}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            _exercisesTotal == 0
                ? 'Nenhum exercício disponível no momento.'
                : 'Você concluiu $_exercisesDone de $_exercisesTotal exercícios disponíveis.',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseListTile(Exercicio exercicio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseDetailScreen(
                exercicio: exercicio,
                onExerciseCompleted: () async {
                  // Recarrega dados do backend para atualizar barra "Feitos" e Diário Pós
                  await _carregarDados();
                },
              ),
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercicio.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${exercicio.duracaoMinutos} Min',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: _tertiaryColor, 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseListView() {
    if (_exercicios.isEmpty) {
      return const Center(child: Text('Nenhum exercício disponível'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Títulos: Lista Exercícios / Selecione um ou mais / Ver todos
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lista Exercícios',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Selecione um ou mais',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(
                      color: _tertiaryColor, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _exercicios.length,
              itemBuilder: (context, index) {
                return _buildExerciseListTile(_exercicios[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiarioPosScreen() {
    if (_historicoExercicios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Diário Pós: ${_exercisesDone} exercícios concluídos!',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Quando você registrar um exercício,\n'
              'ele aparecerá aqui com suas sensações.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: _historicoExercicios.length,
      itemBuilder: (context, index) {
        final registro = _historicoExercicios[index];
        final exercicioNome = registro.exercicio?.nome ?? 'Exercício #${registro.exercicioId}';
        final data = registro.dataHora;
        final dataStr =
            '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
        final horaStr =
            '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: _progressDoneColor),
            title: Text(
              exercicioNome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duração: ${registro.duracao} min'),
                Text('Data: $dataStr • $horaStr'),
                if (registro.observacoes != null &&
                    registro.observacoes!.trim().isNotEmpty)
                  const SizedBox(height: 4),
                if (registro.observacoes != null &&
                    registro.observacoes!.trim().isNotEmpty)
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Sensações: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: registro.observacoes,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white, // Fundo branco
        
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130.0), 
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: const BoxDecoration(
              color: _appBarSolidColor, 
            ),
            child: Column(
              children: [
                // 1. Título e Botão de Voltar
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back), color: Colors.black, onPressed: () => Navigator.of(context).pop(),),
                      const Expanded(child: Center(child: Text('Exercícios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),),),),
                      const SizedBox(width: 48), 
                    ],
                  ),
                ),
                
                // 2. TabBar (Lista e Diário Pós)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: _secondaryColor, borderRadius: BorderRadius.circular(25),),
                    child: TabBar(
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 2),),],),
                      indicatorSize: TabBarIndicatorSize.tab, indicatorPadding: EdgeInsets.zero,
                      labelColor: Colors.black, unselectedLabelColor: Colors.grey.shade600, labelStyle: const TextStyle(fontWeight: FontWeight.bold), unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                      tabs: const [Tab(text: 'Lista'), Tab(text: 'Diário Pós'),],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: Column(
          children: [
            // BARRA DE PROGRESSO
            const SizedBox(height: 10), 
            _buildProgressCard(), 
            const SizedBox(height: 10),
            
            // CONTEÚDO PRINCIPAL 
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text('Erro: $_error'),
                              const SizedBox(height: 16),
                              ElevatedButton(onPressed: _carregarDados, child: const Text('Tentar Novamente'),),
                            ],
                          ),
                        )
                      : TabBarView(
                          children: [
                            _buildExerciseListView(),
                            _buildDiarioPosScreen(),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}