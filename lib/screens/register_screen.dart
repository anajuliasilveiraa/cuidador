// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'set_password_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();
  final _telefoneController = TextEditingController();

  String _sexo = 'Feminino';
  bool _aceitouTermos = false;
  DateTime? _dataNascimento;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _idadeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  int? _calcularIdade(DateTime? dataNascimento) {
    if (dataNascimento == null) return null;
    final now = DateTime.now();
    int idade = now.year - dataNascimento.year;

    if (now.month < dataNascimento.month ||
        (now.month == dataNascimento.month &&
            now.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );

    if (picked != null) {
      final idade = _calcularIdade(picked);

      if (idade != null && idade >= 18) {
        setState(() {
          _dataNascimento = picked;
          _idadeController.text = idade.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Idade mínima de 18 anos é requerida.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToSetPassword() {
    if (!_formKey.currentState!.validate()) return;

    final idadeInt = _calcularIdade(_dataNascimento);

    if (idadeInt == null || idadeInt < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data de nascimento inválida.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SetPasswordScreen(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          idade: idadeInt,
          sexo: _sexo,
          telefone: _telefoneController.text.trim().isEmpty
              ? null
              : _telefoneController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const lavandaClaro = Color(0xFF9BA1D9);
    const botaoLavanda = Color(0xFF949DE8);

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: 1.3),
        );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Voltar',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Cadastre-se',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 48),

                // Nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    hintText: 'Nome Completo',
                    enabledBorder: border(Colors.grey.shade300),
                    focusedBorder: border(lavandaClaro),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nome obrigatório' : null,
                ),

                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    enabledBorder: border(Colors.grey.shade300),
                    focusedBorder: border(lavandaClaro),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                  ),
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'E-mail inválido' : null,
                ),

                const SizedBox(height: 16),

                // Telefone
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Telefone',
                    prefixIcon: const Icon(Icons.phone_outlined),

                    enabledBorder: border(Colors.grey.shade300),
                    focusedBorder: border(lavandaClaro),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                  ),
                ),

                const SizedBox(height: 16),

                // Data de nascimento
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'Data de nascimento',
                      prefixIcon:
                          const Icon(Icons.calendar_today_outlined),

                      enabledBorder: border(Colors.grey.shade300),
                      focusedBorder: border(lavandaClaro),
                    ),
                    child: Text(
                      _dataNascimento == null
                          ? ''
                          : '${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Sexo
                DropdownButtonFormField<String>(
                  initialValue: _sexo,
                  decoration: InputDecoration(
                    hintText: 'Sexo',
                    prefixIcon: const Icon(Icons.person_outline),

                    enabledBorder: border(Colors.grey.shade300),
                    focusedBorder: border(lavandaClaro),
                  ),
                  items: ['Feminino', 'Masculino', 'Outro']
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _sexo = v!),
                ),

                const SizedBox(height: 30),

                // Checkbox Termos
                Row(
                  children: [
                    Checkbox(
                      value: _aceitouTermos,
                      onChanged: (v) =>
                          setState(() => _aceitouTermos = v!),
                      activeColor: lavandaClaro,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(
                            () => _aceitouTermos = !_aceitouTermos),
                        child: Text(
                          'Ao se cadastrar, você concorda com os Termos de Serviço e a Política de Privacidade.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // Botão Cadastrar
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: botaoLavanda,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _navigateToSetPassword,
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta?',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: botaoLavanda,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
