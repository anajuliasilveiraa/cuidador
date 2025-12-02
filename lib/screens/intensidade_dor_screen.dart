import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

// Constantes de Cores e Dados
const Color _primaryColor = Color(0xFF8C9EFF); // Lilás principal
const Color _sliderActiveColor = Color(0xFFF9A893); // Cor Laranja/Salmão do slider
const Color _sliderInactiveColor = Color(0xFFE0E0E0); // Cinza do trilho

// Definição dos níveis de dor
class NivelDor {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color corIcone;
  final int valor;

  const NivelDor(this.titulo, this.descricao, this.icone, this.corIcone, this.valor);
}

const List<NivelDor> _niveisDor = [
  NivelDor('Sem Dor', 'COMPLETAMENTE CONFORTÁVEL', Icons.sentiment_satisfied_alt, Color(0xFF8BC34A), 0), 
  NivelDor('Dor Mínima', 'DESCONFORTO LEVE E FÁCIL DE IGNORAR.', Icons.sentiment_neutral, Color(0xFFFFEB3B), 1),
  NivelDor('Dor Leve', 'PERCEPTÍVEL, MAS NÃO ATRAPALHA O DIA.', Icons.sentiment_neutral, Color(0xFFFFC107), 2),
  NivelDor('Dor Moderada', 'INTERFERE NAS TAREFAS, MAS AINDA É POSSÍVEL.', Icons.sentiment_very_dissatisfied, Color(0xFFFF9800), 3),
  NivelDor('Dor Intensa', 'DIFÍCIL DE IGNORAR, LIMITA ATIVIDADES.', Icons.mood_bad, Color(0xFF9C27B0), 4),
  NivelDor('Dor Insuportável', 'A PIOR DOR, REQUER AJUDA IMEDIATA.', Icons.sentiment_very_dissatisfied, Color(0xFFD32F2F), 5), 
];

class IntensidadeDorScreen extends StatefulWidget {
  const IntensidadeDorScreen({super.key});

  @override
  State<IntensidadeDorScreen> createState() => _IntensidadeDorScreenState();
}

class _IntensidadeDorScreenState extends State<IntensidadeDorScreen> {
  int _selectedLevel = 3; // Começa em Moderada
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  Future<void> _registrarDor() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sessão expirada. Faça login novamente para registrar sua dor.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final nivel = _niveisDor[_selectedLevel];
      await _apiService.registerPain(
        token: token,
        intensidade: nivel.valor,
        localizacao: 'Geral',
        observacoes: nivel.descricao,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro de dor salvo com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar dor: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inverter para mostrar "Sem Dor" no topo
    final displayLevels = _niveisDor.reversed.toList();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black), 
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 5,
            child: const LinearProgressIndicator(
              value: 0.5, 
              backgroundColor: _sliderInactiveColor,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            ),
          ),
          centerTitle: true,
        ),
      ),
      
      body: Padding( 
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 30.0),
              child: Text(
                'Como está sua dor hoje?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // Lista de níveis de dor com seleção por toque
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayLevels.length,
                itemBuilder: (context, index) {
                  final nivel = displayLevels[index];
                  final isSelected = nivel.valor == _selectedLevel;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = nivel.valor;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isSelected ? _sliderActiveColor.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _sliderActiveColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Emoji
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: nivel.corIcone.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              nivel.icone,
                              size: 32,
                              color: nivel.corIcone,
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Texto
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nivel.titulo.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.black87 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  nivel.descricao,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.black54 : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Indicador de seleção
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: _sliderActiveColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      // Botão "Próximo" na parte inferior
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _registrarDor,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor.withOpacity(0.8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}