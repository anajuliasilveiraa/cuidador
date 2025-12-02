import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercicio.dart';
import '../main.dart' as main_app;
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class DiarioPosScreen extends StatefulWidget {
  final Exercicio exercicio;

  const DiarioPosScreen({super.key, required this.exercicio});

  @override
  State<DiarioPosScreen> createState() => _DiarioPosScreenState();
}

class _DiarioPosScreenState extends State<DiarioPosScreen> {
  final _sensacoesController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  Future<void> _submitLog() async {
    final observacoes = _sensacoesController.text.trim();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sessão expirada. Faça login novamente para registrar o exercício.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _apiService.logExercise(
        token: token,
        exercicioId: widget.exercicio.id,
        duracao: widget.exercicio.duracaoMinutos,
        observacoes: observacoes.isEmpty ? null : observacoes,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercício registrado com sucesso no diário!')),
      );

      // Volta apenas para a tela anterior (detalhes do exercício);
      // de lá o usuário pode retornar à lista normalmente.
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar exercício: $e')),
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
  void dispose() {
    _sensacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = main_app.primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Diário Pós-Exercício'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.exercicio.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 30),

            // Passos do Exercício para referência
            const Text(
              'Revisão dos Passos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...widget.exercicio.passos.map((passo) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: main_app.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(passo, style: const TextStyle(fontSize: 16)),
                ),
              );
            }),
            
            const SizedBox(height: 30),

            // Campo Sensações
            const Text(
              'Sensações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Exemplos: \"senti leveza no joelho\", \"fiquei cansada, mas sem dor forte\", '
              '\"a dor diminuiu de 7 para 5\".',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sensacoesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Descreva como você se sentiu após o exercício...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 40),

            // Botão Finalizar Registro
            ElevatedButton(
          onPressed: _isSubmitting ? null : _submitLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
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
                  'Finalizar Registro',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ),
          ],
        ),
      ),
    );
  }
}