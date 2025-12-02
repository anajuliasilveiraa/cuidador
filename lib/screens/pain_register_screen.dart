// ignore_for_file: unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../main.dart' as main_app; 
class PainRegisterScreen extends StatefulWidget {
  const PainRegisterScreen({super.key});

  @override
  State<PainRegisterScreen> createState() => _PainRegisterScreenState();
}

class _PainRegisterScreenState extends State<PainRegisterScreen> {
  final ApiService _apiService = ApiService();
  final _observacoesController = TextEditingController();
  
  final double _intensidadeDor = 5.0;
  String? _localizacao;
  bool _isLoading = false;
  int _currentStep = 0; // 0: Intensidade/Localização, 1: Observações

  final List<String> _localizacoes = [
    'Pescoço', 
    'Ombros',
    'Costas', 
    'Quadril',
    'Mãos',
    'Joelho', 
    'Pés',
  ];

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  String _getDescricaoDor(double intensidade) {
    int valor = intensidade.round();
    if (valor == 0) return 'Sem dor';
    if (valor <= 2) return 'Dor Mínima';
    if (valor <= 4) return 'Dor Leve';
    if (valor <= 6) return 'Dor Moderada';
    if (valor <= 8) return 'Dor Intensa';
    return 'Dor Insuportável';
  }

  Color _getCorDor(double intensidade) {
    int valor = intensidade.round();
    if (valor <= 2) return Colors.green.shade400;
    if (valor <= 4) return Colors.yellow.shade700;
    if (valor <= 6) return main_app.accentColor; 
    if (valor <= 8) return Colors.red.shade400;
    return Colors.red.shade700;
  }

  Future<void> _registrarDor() async {
    if (_localizacao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione a localização da dor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await _apiService.registerPain(
        token: authProvider.token!,
        intensidade: _intensidadeDor.round(),
        localizacao: _localizacao!,
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dor registrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar dor: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Widget para os chips de localização (ao lado do corpo)
  Widget _buildLocationChip(String loc) {
    final isSelected = _localizacao == loc;
    const primaryColor = main_app.primaryColor;
    final lavandaClaro = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _localizacao = isSelected ? null : loc;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? lavandaClaro : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          loc,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = main_app.primaryColor;
    final lavandaClaro = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Dores'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Onde você sente dor?',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16),
            
            // Layout Principal: Lista de Chips de Localização e Imagem do Corpo
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coluna 1: Localizações (Simulando o alinhamento vertical do protótipo)
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _localizacoes.map(_buildLocationChip).toList(),
                  ),
                ),

                const SizedBox(width: 16),
                
                // Coluna 2: Imagem do Corpo (assets/corpofem.png)
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/corpofem.png',
                          height: 350,
                          fit: BoxFit.contain,
                          color: lavandaClaro.withOpacity(0.7), 
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            //"Ou"
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Ou', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 1;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: BorderSide(color: lavandaClaro, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Digite os sintomas manualmente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 40),
            
            // Card de Intensidade (Moveremos a intensidade para a Etapa 2 para simplificar o layout)
            
            // Botão de Registrar (Finaliza com Intensidade e Observações)
            ElevatedButton(
              onPressed: _isLoading ? null : _registrarDor,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Registrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
          ],
        ),
      ),
    );
  }
}