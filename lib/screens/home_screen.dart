// ignore_for_file: unused_element, unused_local_variable, unnecessary_brace_in_string_interps, unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // ADICIONAR ESTA LINHA
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'exercises_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'education_screen.dart';
import 'intensidade_dor_screen.dart'; 
import 'pain_register_screen.dart'; 

const Color _primaryColor = Color(0xFF0088FF); // Azul
const Color _lavandaClaro = Color(0xFFC8CCFF); // Lavanda
const Color _lavandaBotao = Color(0xFF949de8); // Lavanda Escuro
const Color _iconGreyColor = Color(0xFFB8B8B8); // Cinza
const Color _orangeIconColor = Color(0xFFFF501E); // Laranja
const Color _amareloClaro = Color(0xFFFFFCE3); // Amarelo Claro

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const ExercisesScreen(), 
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: _iconGreyColor),
            selectedIcon: Icon(Icons.home, color: _iconGreyColor),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined, color: _iconGreyColor),
            selectedIcon: Icon(Icons.self_improvement, color: _iconGreyColor),
            label: 'Exercícios',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_graph, color: _iconGreyColor),
            selectedIcon: Icon(Icons.assessment, color: _iconGreyColor),
            label: 'Relatórios',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: _iconGreyColor),
            selectedIcon: Icon(Icons.person, color: _iconGreyColor),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// =======================================================
//                   HOME TAB
// =======================================================

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ApiService _apiService = ApiService();
  Set<String> _diasComRegistro = {}; // Datas no formato 'yyyy-MM-dd'
  bool _loadingCalendar = true;

  @override
  void initState() {
    super.initState();
    _carregarRegistrosDor();
  }

  Future<void> _carregarRegistrosDor() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.token == null) {
        setState(() {
          _loadingCalendar = false;
        });
        return;
      }

      // Busca histórico de dor dos últimos 30 dias
      final now = DateTime.now();
      final dataInicio = now.subtract(const Duration(days: 30));
      
      final registros = await _apiService.getPainHistory(
        token: authProvider.token!,
        dataInicio: dataInicio,
        dataFim: now,
      );

      // Extrai as datas dos registros
      final Set<String> datas = {};
      for (var registro in registros) {
        if (registro['data_hora'] != null) {
          final DateTime data = DateTime.parse(registro['data_hora']);
          datas.add(DateFormat('yyyy-MM-dd').format(data));
        }
      }

      setState(() {
        _diasComRegistro = datas;
        _loadingCalendar = false;
      });
    } catch (e) {
      print('Erro ao carregar registros: $e');
      setState(() {
        _loadingCalendar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuario = authProvider.usuario;

    const Color primaryColor = _primaryColor;
    const Color lavandaClaro = _lavandaClaro;
    const Color cardIconColor = _orangeIconColor;
    const Color nameColor = _lavandaBotao;

    final List<String> nomeCompleto = usuario?.nome.split(' ') ?? ['Usuário'];
    final String primeiroNome = nomeCompleto.isNotEmpty ? nomeCompleto.first : 'Usuário';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0, 
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header (Olá, Usuário + Avatar)
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 24, right: 24, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Lado Esquerdo: Saudação e Nome 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Olá,', 
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        primeiroNome, 
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: nameColor),
                      ),
                    ],
                  ), 
                  Transform.translate(
                    offset: const Offset(40, 0), 
                    child: Image.asset(
                      'assets/logo.png',
                      width: 225,
                      height: 210,
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),
            
            // 2. Calendário Horizontal
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
              child: _loadingCalendar
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _buildCalendarRow(primaryColor, lavandaClaro),
            ),
            
            const SizedBox(height: 20),

            // 3. Card de Lembrete/Motivação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _amareloClaro,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Lembre-se: Osteoartrite é parte de você, mas NÃO define quem você é!',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold), 
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. Seção "Explore Mais" (Cartões de Ações)
            const Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Text(
                'Explore Mais',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            // CARD: Escala Dor
            _buildExploreCard(
              context,
              title: 'Escala Dor',
              subtitle: 'Registre a intensidade da sua dor',
              icon: Icons.mood_bad_outlined,
              color: cardIconColor,
              onTap: () { 
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const IntensidadeDorScreen())
                ).then((_) {
                  // Recarrega o calendário após registrar dor
                  _carregarRegistrosDor();
                }); 
              }
            ),
            
            // Cartão: Hábitos
            _buildExploreCard(
              context,
              title: 'Hábitos',
              subtitle: 'Há 2 dias praticando exercícios',
              icon: Icons.access_time,
              color: cardIconColor,
              onTap: () { 
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const ExercisesScreen())
                ); 
              }
            ),
            
            // Cartão: Acompanhamento
            _buildExploreCard(
              context,
              title: 'Acompanhamento',
              subtitle: 'Veja suas métricas',
              icon: Icons.remove_red_eye_outlined, 
              color: cardIconColor,
              onTap: () { 
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const ReportsScreen())
                ); 
              }
            ),
            
            // Cartão: Educação
            _buildExploreCard(
              context,
              title: 'Educação',
              subtitle: 'Aprenda sobre osteoartrite',
              icon: Icons.school_outlined,
              color: cardIconColor,
              onTap: () { 
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const EducationScreen())
                ); 
              }
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // CALENDÁRIO COM DATAS DINÂMICAS E REGISTROS
  // ===================================================
  
  Widget _buildCalendarRow(Color primaryColor, Color lavandaClaro) {
    final DateTime now = DateTime.now();
    final int currentDay = now.day;
    final int currentMonth = now.month;
    final int currentYear = now.year;
    
    // Calcula o primeiro dia da semana atual (domingo)
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    
    // Lista com os 7 dias da semana atual
    final List<DateTime> weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
    
    // Nomes dos dias da semana (português)
    final List<String> dayNames = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
    
    const Color buttonColor = _lavandaBotao;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMM yyyy').format(now),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        
        // Row com os dias da semana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = weekDates[index];
            final isToday = date.day == currentDay && 
                            date.month == currentMonth && 
                            date.year == currentYear;
            
            // Verifica se existe registro de dor neste dia
            final dateKey = DateFormat('yyyy-MM-dd').format(date);
            final hasRecord = _diasComRegistro.contains(dateKey);
            
            return Column(
              children: [
                Text(
                  dayNames[index],
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasRecord ? buttonColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isToday ? buttonColor : Colors.transparent,
                      width: isToday ? 2.0 : 0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: hasRecord 
                            ? Colors.white 
                            : (isToday ? buttonColor : Colors.black87),
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  // ===================================================
  // CARTÕES DE "EXPLORE MAIS"
  // ===================================================

  Widget _buildExploreCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}