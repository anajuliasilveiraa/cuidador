import 'package:flutter/material.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos e Privacidade'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termos de Serviço do CuidaDor',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Aceitação dos Termos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Ao utilizar o aplicativo CuidaDor, você concorda integralmente com estes Termos de Serviço e com a nossa Política de Privacidade. Caso não concorde, por favor, não utilize a plataforma.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 15),
            const Text(
              '2. Objetivo do Aplicativo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'O CuidaDor é uma ferramenta de apoio ao autocuidado para condições osteoarticulares, como a osteoartrite. Ele não substitui o diagnóstico, a consulta médica ou o tratamento profissional. As funcionalidades incluem registro de dor, acompanhamento de hábitos e lembretes.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 30),
            Text(
              'Política de Privacidade',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Coleta e Uso de Dados Pessoais',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Coletamos dados de registro (nome, e-mail, idade, sexo) e dados de uso (registros de dor, hábitos de exercício e objetivos) para personalizar sua experiência e fornecer relatórios de evolução. Seus dados são criptografados e armazenados em segurança.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 15),
            const Text(
              '4. Exclusão de Dados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Você pode solicitar a exclusão completa de sua conta e de todos os dados associados a qualquer momento através do menu Perfil.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}