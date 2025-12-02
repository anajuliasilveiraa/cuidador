import 'package:cuidador_app/screens/pain_register_screen.dart';
import 'package:cuidador_app/screens/wellbeing_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // importando FL Chart
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart' as main_app;
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import '../models/wellbeing_entry.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = ApiService();
  List<double> _painData = [];
  final List<Map<String, String>> _meds = [
    {
      'nome': 'Diclofenaco',
      'dose': '50 mg',
      'horario': '08:00, 20:00',
    },
    {
      'nome': 'Vitaminas',
      'dose': '1 comprimido',
      'horario': '10:00',
    },
  ];
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _painRegistros = [];
  double? _mediaDor;
  double? _menorDor;
  double? _maiorDor;
  List<WellbeingEntry> _wellbeingEntries = [];

  @override
  void initState() {
    super.initState();
    _carregarHistoricoDor();
    _carregarBemEstar();
  }

  Future<void> _carregarHistoricoDor() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;
      if (token == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final now = DateTime.now();
      final dataInicio = now.subtract(const Duration(days: 7));

      final registros = await _apiService.getPainHistory(
        token: token,
        dataInicio: dataInicio,
        dataFim: now,
      );

      final List<Map<String, dynamic>> listaRegistros =
          registros.map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r as Map)).toList();

      final List<double> intensidades = listaRegistros
          .map<double>((r) => (r['intensidade'] as num).toDouble())
          .toList();

      double? media;
      double? min;
      double? max;
      if (intensidades.isNotEmpty) {
        double soma = 0;
        min = intensidades.first;
        max = intensidades.first;
        for (final v in intensidades) {
          soma += v;
          if (v < min!) min = v;
          if (v > max!) max = v;
        }
        media = soma / intensidades.length;
      }

      setState(() {
        _painData = intensidades;
        _painRegistros = listaRegistros;
        _mediaDor = media;
        _menorDor = min;
        _maiorDor = max;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _carregarBemEstar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> raw = prefs.getStringList('wellbeing_entries') ?? [];
      final List<WellbeingEntry> entries = raw
          .map((s) => WellbeingEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();

      // Mantém apenas os últimos 30 dias para o resumo
      final now = DateTime.now();
      final cutoff = now.subtract(const Duration(days: 30));
      final filtrados =
          entries.where((e) => e.date.isAfter(cutoff)).toList()..sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _wellbeingEntries = filtrados;
      });
    } catch (_) {
      // Se der erro no parse, apenas ignora para não travar a tela
    }
  }
  
  @override
  Widget build(BuildContext context) {
    const primaryColor = main_app.primaryColor;
    final lavandaClaro = Theme.of(context).colorScheme.secondary;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Evolução Da Dor'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Gráfico de Evolução da Dor
            Container(
              height: 200,
              padding: const EdgeInsets.only(top: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lavandaClaro.withOpacity(0.5), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Text(
                            'Erro ao carregar histórico de dor:\n$_error',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : (_painData.isEmpty
                          ? const Center(
                              child: Text(
                                'Você ainda não registrou sua dor.\nUse o botão abaixo para começar.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : LineChart(_sampleChartData())),
            ),
            
            const SizedBox(height: 30),

            // 1.1 Resumo numérico da dor
            if (_painData.isNotEmpty)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo dos últimos 7 dias',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetricItem(
                            label: 'Média da dor',
                            value: _mediaDor != null ? _mediaDor!.toStringAsFixed(1) : '-',
                          ),
                          _buildMetricItem(
                            label: 'Pior dia',
                            value: _maiorDor != null ? _maiorDor!.toStringAsFixed(0) : '-',
                          ),
                          _buildMetricItem(
                            label: 'Melhor dia',
                            value: _menorDor != null ? _menorDor!.toStringAsFixed(0) : '-',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total de registros de dor: ${_painData.length}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // 2. Bloco de Sono e Humor
            if (_wellbeingEntries.isNotEmpty) ...[
              const Text(
                'Sono e humor',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildWellbeingSummaryCard(),
              const SizedBox(height: 24),
            ] else ...[
              const Text(
                'Sono e humor',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Registre como você dormiu e como está se sentindo para acompanhar seu bem-estar ao longo do tempo.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 12),
            ],

            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WellbeingScreen()),
                  ).then((saved) {
                    if (saved == true) {
                      _carregarBemEstar();
                    }
                  });
                },
                icon: const Icon(Icons.self_improvement_outlined),
                label: const Text('Registrar sono e humor'),
              ),
            ),

            const SizedBox(height: 30),

            // 3. Cartões de Remédios (Seus Remédios)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seus Remédios',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showAddMedicineDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Registre aqui os medicamentos que você usa com frequência para acompanhar horários e doses.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            
            ..._meds.asMap().entries.map(
              (entry) => _buildMedicineCard(
                context,
                entry.key,
                entry.value,
                primaryColor,
              ),
            ),
            
            const SizedBox(height: 30),

            // 3. Atualize sua Dor (Botão/Card Diário)
            const Text(
              'Atualize sua dor',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildDailyPainCard(context, primaryColor, lavandaClaro),

            const SizedBox(height: 30),

            // 4. Registros recentes de dor (Histórico real)
            const Text(
              'Registros recentes de dor',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            if (_painRegistros.isEmpty)
              const Text(
                'Você ainda não registrou sintomas de dor.\nUse a escala ou o diário para começar.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              )
            else
              Column(
                children: _buildRecentPainEntries(primaryColor, lavandaClaro),
              ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // --- FL CHART DATA (Mock) ---
  LineChartData _sampleChartData() {
    if (_painData.isEmpty) {
      return LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      );
    }

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_painData.length - 1).toDouble(),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: _painData.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value);
          }).toList(),
          isCurved: true,
          color: main_app.accentColor,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildMetricItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildWellbeingSummaryCard() {
    if (_wellbeingEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    // Usa até os últimos 7 registros para média
    final recent = _wellbeingEntries.take(7).toList();
    double sumSleep = 0;
    double sumMood = 0;
    for (final e in recent) {
      sumSleep += e.sleepQuality;
      sumMood += e.mood;
    }
    final avgSleep = sumSleep / recent.length;
    final avgMood = sumMood / recent.length;

    final last = _wellbeingEntries.first;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-estar recente',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricItem(
                  label: 'Sono médio (0–10)',
                  value: avgSleep.toStringAsFixed(1),
                ),
                _buildMetricItem(
                  label: 'Humor médio (0–10)',
                  value: avgMood.toStringAsFixed(1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Último registro: sono ${last.sleepQuality}/10 • humor ${last.mood}/10',
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            if (last.notes != null && last.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                last.notes!,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(
    BuildContext context,
    int index,
    Map<String, String> med,
    Color primaryColor,
  ) {
    final String nome = med['nome'] ?? 'Medicamento';
    final String dose = med['dose'] ?? '';
    final String horario = med['horario'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.medication, color: primaryColor),
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dose.isNotEmpty)
              Text(
                'Dose: $dose',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            if (horario.isNotEmpty)
              Text(
                'Horários: $horario',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'tomado') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Registrado que você tomou $nome agora.'),
                ),
              );
            } else if (value == 'remover') {
              setState(() {
                _meds.removeAt(index);
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'tomado',
              child: Text('Marcar como tomado agora'),
            ),
            const PopupMenuItem(
              value: 'remover',
              child: Text('Remover da lista'),
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
        onTap: () {
          _showEditMedicineDialog(context, index, med);
        },
      ),
    );
  }

  Widget _buildDailyPainCard(BuildContext context, Color primaryColor, Color lavandaClaro) {
    return Card(
      color: lavandaClaro.withOpacity(0.5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: const Text('Diário de Dor', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Conte como você se sentiu e atualize sua dor.'),
        trailing: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PainRegisterScreen()));
        },
      ),
    );
  }

  List<Widget> _buildRecentPainEntries(Color primaryColor, Color lavandaClaro) {
    // Ordena do mais recente para o mais antigo e pega no máximo 5
    final List<Map<String, dynamic>> ordenados = [..._painRegistros];
    ordenados.sort((a, b) {
      final da = DateTime.parse(a['data_hora'] as String);
      final db = DateTime.parse(b['data_hora'] as String);
      return db.compareTo(da);
    });

    final selecionados = ordenados.take(5);

    return selecionados.map((registro) {
      final dataHora = DateTime.parse(registro['data_hora'] as String);
      final intensidade = (registro['intensidade'] as num).toDouble();
      final localizacao = registro['localizacao'] as String?;
      final observacoes = registro['observacoes'] as String?;

      final dataStr =
          '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year}';
      final horaStr =
          '${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(
            'Dor ${intensidade.toStringAsFixed(0)} / 10',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data: $dataStr • $horaStr',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              if (localizacao != null && localizacao.isNotEmpty)
                Text(
                  'Local: $localizacao',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              if (observacoes != null && observacoes.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    observacoes,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              intensidade.toStringAsFixed(0),
              style: TextStyle(color: primaryColor, fontSize: 12),
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _showAddMedicineDialog(BuildContext context) async {
    final nomeController = TextEditingController();
    final doseController = TextEditingController();
    final horarioController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Adicionar medicamento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do medicamento',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: doseController,
                  decoration: const InputDecoration(
                    labelText: 'Dose (ex: 50 mg, 1 comprimido)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: horarioController,
                  decoration: const InputDecoration(
                    labelText: 'Horários (ex: 08:00, 20:00)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomeController.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  _meds.add({
                    'nome': nomeController.text.trim(),
                    'dose': doseController.text.trim(),
                    'horario': horarioController.text.trim(),
                  });
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditMedicineDialog(
    BuildContext context,
    int index,
    Map<String, String> med,
  ) async {
    final nomeController = TextEditingController(text: med['nome'] ?? '');
    final doseController = TextEditingController(text: med['dose'] ?? '');
    final horarioController = TextEditingController(text: med['horario'] ?? '');

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Editar medicamento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do medicamento',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: doseController,
                  decoration: const InputDecoration(
                    labelText: 'Dose (ex: 50 mg, 1 comprimido)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: horarioController,
                  decoration: const InputDecoration(
                    labelText: 'Horários (ex: 08:00, 20:00)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomeController.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  _meds[index] = {
                    'nome': nomeController.text.trim(),
                    'dose': doseController.text.trim(),
                    'horario': horarioController.text.trim(),
                  };
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}