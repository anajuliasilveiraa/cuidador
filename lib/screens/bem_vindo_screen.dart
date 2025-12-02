// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../main.dart' as main_app;
import 'login_screen.dart';
import 'register_screen.dart';

class BemVindoScreen extends StatelessWidget {
  const BemVindoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color lavandaClaro = Theme.of(context).colorScheme.secondary; 

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Imagem
              Center(
                child: SizedBox(
                  width: 350,
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.asset(
                      'assets/logo.png',
                      //fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Título Principal
              const Text(
                'CuidaDor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8C9EFF),
                ),
              ),

              const SizedBox(height: 8),

              // Subtítulo
              Text(
                'Suporte à Dor por Osteoartrite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              
              const Spacer(flex: 3),

              // Botão Cadastrar (Preenchido, cor primária do protótipo: Lavanda Claro)
              ElevatedButton(
                onPressed: () {
                  // CORRIGIDO: Usando MaterialPageRoute
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lavandaClaro, // Cor de fundo: Lavanda
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Cor do texto: Azul
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão Entrar (Borda, texto em azul)
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(149, 165, 255, 1), // Cor do texto
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: BorderSide(color: lavandaClaro, width: 2), // Borda Lavanda
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}