import 'package:flutter/material.dart';
import '../models/exercicio.dart';
import 'diario_pos_screen.dart'; // Tela de Diário Pós

class ExerciseDetailScreen extends StatelessWidget {
  final Exercicio exercicio;
  // NOVO: Adicione uma função de callback para notificar a tela anterior (ExercisesScreen)
  // sobre uma possível atualização (para o checkmark aparecer).
  final Function? onExerciseCompleted; 

  const ExerciseDetailScreen({
    Key? key, 
    required this.exercicio, 
    this.onExerciseCompleted, 
  }) : super(key: key);


  // Cor padrão do tema (Azul forte, como era o original antes das customizações dinâmicas)
  final Color _defaultThemeColor = const Color(0xFF1976D2); // Colors.blue.shade700
  
  final IconData _defaultIconData = Icons.fitness_center;


  @override
  Widget build(BuildContext context) {
    final Color themeColor = _defaultThemeColor;
    
    final IconData iconData = _defaultIconData;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercicio.nome),
        backgroundColor: themeColor, // Usa a cor padrão
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card com informações de Tempo e Categoria
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: themeColor),
                        const SizedBox(width: 8),
                        Text('${exercicio.duracaoMinutos} minutos', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.category, color: themeColor),
                        const SizedBox(width: 8),
                        Text(exercicio.categoria, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(iconData, color: themeColor),
                        const SizedBox(width: 8),
                        Text(exercicio.categoria, style: const TextStyle(fontSize: 16)), 
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Descrição
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(exercicio.descricao, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            
            // Passos (Como Fazer)
            if (exercicio.passos.isNotEmpty) ...[
              const Text(
                'Como Fazer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...exercicio.passos.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: themeColor, // Cor padrão
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 24),

            // Atenção / Alertas de segurança
            const Text(
              'Atenção',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Pare se sentir dor forte ou tontura intensa.\n'
              '• Não force articulações muito inchadas ou vermelhas.\n'
              '• Em caso de dúvida, converse com seu profissional de saúde.',
              style: TextStyle(fontSize: 14, color: Colors.redAccent),
            ),

            const SizedBox(height: 32),
            
            // Botão Iniciar Exercício
            ElevatedButton(
              onPressed: () async {
                // Navega para a tela de Diário Pós
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DiarioPosScreen(exercicio: exercicio), 
                  ),
                );
                
                if (onExerciseCompleted != null) {
                  onExerciseCompleted!();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Iniciar Exercício',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}