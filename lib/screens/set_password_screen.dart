import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import '../main.dart' as main_app; 

class SetPasswordScreen extends StatefulWidget {
  final String nome;
  final String email;
  final int idade;
  final String sexo;
  final String? telefone;

  const SetPasswordScreen({
    super.key,
    required this.nome,
    required this.email,
    required this.idade,
    required this.sexo,
    this.telefone,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _handleRegisterFinal() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() { _isLoading = true; });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      nome: widget.nome,
      email: widget.email,
      senha: _senhaController.text,
      idade: widget.idade,
      sexo: widget.sexo,
      telefone: widget.telefone,
    );

    if (!mounted) return;

    setState(() { _isLoading = false; });

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (Route<dynamic> route) => false, // Remove todas as rotas anteriores
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Erro desconhecido ao finalizar cadastro'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = main_app.primaryColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Senha'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                const Text(
                  'Configure sua senha',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 48),

                // Campo Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Entre sua senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () { setState(() { _obscurePassword = !_obscurePassword; }); },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Confirmar Senha
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirme a senha digitada',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () { setState(() { _obscureConfirmPassword = !_obscureConfirmPassword; }); },
                    ),
                  ),
                  validator: (value) {
                    if (value != _senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Dica de Segurança
                const Text(
                  'Atenção: Pelo menos 1 número e 1 caractere especial são recomendados.',
                  style: TextStyle(fontSize: 12, color: primaryColor), 
                ),

                const SizedBox(height: 48),
                
                // Botão Registrar
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegisterFinal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Registrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}