import 'package:flutter/material.dart';

// Constantes de Cores
const Color _primaryColor = Color(0xFF8C9EFF); // Lilás/Lavanda
const Color _selectedBackground = Color(0xFFD5DBFF); // Lavanda claro para selecionado
const Color _progressBarActive = Color(0xFF2C3E50); // Cinza escuro da barra de progresso
const Color _progressBarInactive = Color(0xFFE0E0E0); // Cinza claro

class ObjetivoScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const ObjetivoScreen({super.key, this.userData});

  @override
  State<ObjetivoScreen> createState() => _ObjetivoScreenState();
}

class _ObjetivoScreenState extends State<ObjetivoScreen> {
  final List<Map<String, dynamic>> _objetivos = [
    {'titulo': 'Reduzir dor', 'icone': Icons.add_circle_outline},
    {'titulo': 'Aprender sobre minha condição', 'icone': Icons.school_outlined},
    {'titulo': 'Monitorar sintomas', 'icone': Icons.analytics_outlined},
    {'titulo': 'Praticar técnicas de relaxamento', 'icone': Icons.spa_outlined},
    {'titulo': 'Só estou explorando o app', 'icone': Icons.explore_outlined},
  ];

  final List<String> _objetivosSelecionados = [];

  void _toggleObjetivo(String objetivo) {
    setState(() {
      if (_objetivosSelecionados.contains(objetivo)) {
        _objetivosSelecionados.remove(objetivo);
      } else {
        _objetivosSelecionados.add(objetivo);
      }
    });
  }

  void _navigateToNextStep() {
    // Lógica para navegar para a próxima tela
    // Navigator.push(...);
    print('Objetivos selecionados: $_objetivosSelecionados');
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: _progressBarInactive,
              valueColor: AlwaysStoppedAnimation<Color>(_progressBarActive),
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 10),
              child: TextButton(
                onPressed: _navigateToNextStep,
                child: const Text(
                  'Pular',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
                children: [
                  TextSpan(text: 'Qual seu objetivo com\no '),
                  TextSpan(
                    text: 'CuidaDor',
                    style: TextStyle(color: _primaryColor),
                  ),
                  TextSpan(text: '?'),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Lista de Objetivos
            Expanded(
              child: ListView.builder(
                itemCount: _objetivos.length,
                itemBuilder: (context, index) {
                  final objetivo = _objetivos[index];
                  final titulo = objetivo['titulo'] as String;
                  final icone = objetivo['icone'] as IconData;
                  final isSelected = _objetivosSelecionados.contains(titulo);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () => _toggleObjetivo(titulo),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedBackground
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? _primaryColor.withOpacity(0.5)
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Ícone
                            Icon(
                              icone,
                              color: isSelected
                                  ? _primaryColor
                                  : Colors.grey.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 16),

                            // Texto
                            Expanded(
                              child: Text(
                                titulo,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.black87
                                      : Colors.black54,
                                ),
                              ),
                            ),

                            // Checkbox
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _primaryColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? _primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Botão "Próximo"
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: _navigateToNextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor.withOpacity(0.8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Próximo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}