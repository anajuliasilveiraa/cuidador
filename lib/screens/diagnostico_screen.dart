import 'package:flutter/material.dart';
import '../main.dart' as main_app;
import 'home_screen.dart'; // Próxima tela (Fim do Onboarding)
import 'package:flutter_form_builder/flutter_form_builder.dart'; // Usando form_builder para tags

class DiagnosticoScreen extends StatefulWidget {
  final Map<String, dynamic> userData; // Dados do usuário do registro

  const DiagnosticoScreen({super.key, required this.userData});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _sugestoes = ['Osteoartrite', 'Artrite', 'Lúpus', 'Fibromialgia', 'Gota'];
  final List<String> _diagnosticos = [];

  void _navigateToHome() {
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = main_app.primaryColor;
    final lavandaClaro = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(''), 
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _navigateToHome, // Permite pular
            child: Text('Pular', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Diagnóstico',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Você possui algum diagnóstico relacionado à dor osteoarticular ou doenças associadas?',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              
              const SizedBox(height: 30),
              
              // Ilustração Placeholder (Substitua por um asset real se tiver)
              Center(
                child: Image.asset(
                  'assets/diagnostico_placeholder.png', // Substitua por sua imagem de Diagnóstico
                  height: 180,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.description, size: 100, color: primaryColor),
                ),
              ),

              const SizedBox(height: 48),

              // Campo de Entrada para Diagnóstico/Tags
              FormBuilderTextField(
                name: 'diagnostico',
                decoration: InputDecoration(
                  hintText: 'Digite seus diagnósticos (ex: Artrite)',
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: lavandaClaro, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: lavandaClaro, width: 2),
                  ),
                ),
                onChanged: (value) {
                  // Lógica para adicionar tags ao estado (simplificado)
                },
              ),
              
              const SizedBox(height: 16),
              
              // Sugestões de Tags (Chips)
              Wrap(
                spacing: 8.0,
                children: _sugestoes.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: lavandaClaro.withOpacity(0.5),
                  labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  onDeleted: _diagnosticos.contains(tag) ? () => setState(() => _diagnosticos.remove(tag)) : null,
                  deleteIconColor: primaryColor,
                )).toList(),
              ),

              const Spacer(),
              
              // Botão Próximo (Cor Lavanda do Protótipo)
              ElevatedButton(
                onPressed: _navigateToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: lavandaClaro,
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Próximo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}