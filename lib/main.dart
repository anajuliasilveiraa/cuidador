// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/auth_provider.dart';
// Telas base
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bem_vindo_screen.dart';

// Telas de Onboarding e Fluxo
import 'screens/set_password_screen.dart'; 
import 'screens/objetivo_screen.dart';
import 'screens/diagnostico_screen.dart';
import 'screens/intensidade_dor_screen.dart'; 
import 'screens/privacy_terms_screen.dart'; 
import 'screens/exercises_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/education_screen.dart';
import 'screens/diario_pos_screen.dart'; 

// ---------------------------------------------------------------------------
// 🎨 CORES DO APLICATIVO
// ---------------------------------------------------------------------------

const Color primaryColor = Color(0xFF0088FF); // Azul Principal (Usado para texto/ícones)
const Color secondaryColor = Color(0xFFC8CCFF); // Lavanda/Claro (Usado para fundos/seleção)
const Color accentColor = Color(0xFFF1B19C); // Pêssego/Alaranjado para erro/destaque
const Color buttonColor = Color(0xFF949de8); // Cor específica do botão (Lavanda Escuro, ex: botão "Entrar")

final Color primaryDarkColor = Color.lerp(primaryColor, Colors.black, 0.25)!; 
final Color primaryLightColor = primaryColor.withAlpha((255 * 0.8).round()); 

// ---------------------------------------------------------------------------
// APP
// ---------------------------------------------------------------------------


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const CuidaDorApp());
}

class CuidaDorApp extends StatelessWidget {
  const CuidaDorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CuidaDor',
        theme: ThemeData(
          useMaterial3: true,
          
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor,
            secondary: secondaryColor,
            error: accentColor, 
          ),

          fontFamily: 'DM Sans',

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, // Fundo branco/transparente 
            foregroundColor: Colors.black, // Ícones pretos
            centerTitle: true,
            elevation: 0,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1), 
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),

        // PRIMEIRA TELA
        home: const SplashScreen(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SPLASH SCREEN (ATUALIZADA PARA FICAR IGUAL AO PROTÓTIPO)
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BemVindoScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF949DE8), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image(
              image: AssetImage('assets/logo.png'),
              width: 250,
            ),

            SizedBox(height: 24),

            Text(
              'CuidaDor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
