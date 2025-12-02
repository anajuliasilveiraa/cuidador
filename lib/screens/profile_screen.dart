import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../main.dart' as main_app;
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showInfoBottomSheet(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuario = authProvider.usuario;

    final primaryColor = main_app.primaryColor;
    final secondaryColor = main_app.secondaryColor;

    // Escolhe uma cor de avatar "aleatória", mas estável, baseada no nome
    final List<Color> avatarColors = [
      secondaryColor.withOpacity(0.8),
      const Color(0xFFFFCDD2), // vermelho claro
      const Color(0xFFC8E6C9), // verde claro
      const Color(0xFFFFF9C4), // amarelo claro
      const Color(0xFFB3E5FC), // azul claro
    ];
    int colorIndex = 0;
    if (usuario?.nome != null && usuario!.nome.isNotEmpty) {
      colorIndex = usuario.nome.codeUnits.fold<int>(0, (p, c) => p + c) % avatarColors.length;
    }
    final avatarColor = avatarColors[colorIndex];

    final inicial = (usuario?.nome.isNotEmpty ?? false)
        ? usuario!.nome.trim()[0].toUpperCase()
        : 'U';

    // Escolhe também um emoji de “personagem” estável baseado no nome
    final List<String> avatarEmojis = ['🙂', '🤗', '🧑‍⚕️', '🧘‍♀️', '🌿'];
    int emojiIndex = 0;
    if (usuario?.nome != null && usuario!.nome.isNotEmpty) {
      emojiIndex =
          usuario.nome.codeUnits.fold<int>(0, (p, c) => p + c) % avatarEmojis.length;
    }
    final emoji = avatarEmojis[emojiIndex];

    // Diagnósticos/comorbidades vindos das preferências
    final List<String> diagnosticos =
        (usuario?.preferencias?['diagnosticos'] as List?)?.cast<String>() ?? [];

    // Preferências de acessibilidade (apenas salvas, sem aplicar tema global ainda)
    final Map<String, dynamic> acess =
        (usuario?.preferencias?['acessibilidade'] as Map?)?.cast<String, dynamic>() ?? {};
    final bool highContrast = (acess['altoContraste'] as bool?) ?? false;
    final double fontScale = (acess['tamanhoFonte'] as num?)?.toDouble() ?? 1.0;

    Future<void> _salvarPreferencias({
      List<String>? novosDiagnosticos,
      bool? novoAltoContraste,
      double? novoTamanhoFonte,
    }) async {
      final Map<String, dynamic> prefsAtuais =
          Map<String, dynamic>.from(usuario?.preferencias ?? {});

      if (novosDiagnosticos != null) {
        prefsAtuais['diagnosticos'] = novosDiagnosticos;
      }
      if (novoAltoContraste != null || novoTamanhoFonte != null) {
        final Map<String, dynamic> acessAtual =
            Map<String, dynamic>.from(prefsAtuais['acessibilidade'] ?? {});
        if (novoAltoContraste != null) {
          acessAtual['altoContraste'] = novoAltoContraste;
        }
        if (novoTamanhoFonte != null) {
          acessAtual['tamanhoFonte'] = novoTamanhoFonte;
        }
        prefsAtuais['acessibilidade'] = acessAtual;
      }

      final ok = await authProvider.updateProfile(
        preferencias: prefsAtuais,
      );

      if (ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferências atualizadas com sucesso.')),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível atualizar as preferências.')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho com avatar e nome
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: avatarColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        inicial,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario?.nome ?? 'Usuário',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usuario?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Diagnóstico e comorbidades
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Diagnóstico e comorbidades',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () async {
                            final controller = TextEditingController(
                              text: diagnosticos.join(', '),
                            );
                            await showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Editar diagnósticos'),
                                  content: TextField(
                                    controller: controller,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Ex.: Osteoartrite, Artrite reumatoide, Hipertensão...',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final texto = controller.text.trim();
                                        final lista = texto.isEmpty
                                            ? <String>[]
                                            : texto
                                                .split(',')
                                                .map((s) => s.trim())
                                                .where((s) => s.isNotEmpty)
                                                .toList();
                                        _salvarPreferencias(
                                          novosDiagnosticos: lista,
                                        );
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Salvar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (diagnosticos.isEmpty)
                      const Text(
                        'Você ainda não cadastrou diagnósticos. Isso ajuda a personalizar as recomendações de cuidado.',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: diagnosticos
                            .map(
                              (d) => Chip(
                                label: Text(d),
                                backgroundColor:
                                    secondaryColor.withOpacity(0.5),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informações pessoais
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cake_outlined),
                    title: const Text('Idade'),
                    trailing: Text(
                      usuario?.idade != null
                          ? '${usuario!.idade} anos'
                          : '—',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Sexo'),
                    trailing: Text(usuario?.sexo ?? '—'),
                  ),
                  if (usuario?.telefone != null &&
                      (usuario!.telefone?.isNotEmpty ?? false)) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text('Telefone'),
                      trailing: Text(usuario.telefone ?? '—'),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Preferências e ajuda
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Configurações'),
                    subtitle: const Text(
                      'Ajuste lembretes e notificações do aplicativo.',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showInfoBottomSheet(
                        context,
                        title: 'Configurações',
                        body:
                            'Aqui você poderá ajustar notificações de lembretes, idioma e outras preferências do aplicativo.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.accessibility_new_outlined),
                    title: const Text('Acessibilidade'),
                    subtitle: Text(
                      highContrast
                          ? 'Alto contraste ativado · tamanho da fonte ${fontScale.toStringAsFixed(1)}x'
                          : 'Fonte padrão · contraste padrão',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      bool tempHighContrast = highContrast;
                      double tempFontScale = fontScale;

                      await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('Ajustar acessibilidade'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Alto contraste'),
                                    Switch(
                                      value: tempHighContrast,
                                      onChanged: (v) {
                                        tempHighContrast = v;
                                        (ctx as Element).markNeedsBuild();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tamanho da fonte',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Slider(
                                  value: tempFontScale,
                                  min: 0.9,
                                  max: 1.3,
                                  divisions: 4,
                                  label: '${tempFontScale.toStringAsFixed(1)}x',
                                  onChanged: (v) {
                                    tempFontScale = v;
                                    (ctx as Element).markNeedsBuild();
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _salvarPreferencias(
                                    novoAltoContraste: tempHighContrast,
                                    novoTamanhoFonte: tempFontScale,
                                  );
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Salvar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Ajuda'),
                    subtitle: const Text(
                      'Entenda como o app pode te apoiar no dia a dia.',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showInfoBottomSheet(
                        context,
                        title: 'Ajuda',
                        body:
                            'Encontre orientações sobre como registrar dor, acompanhar métricas e usar as práticas de alívio disponíveis no aplicativo.',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botão de sair
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sair'),
                    content: const Text('Deseja realmente sair da sua conta?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await authProvider.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}