import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/wellbeing_entry.dart';

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({super.key});

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  int _sleep = 7;
  int _mood = 7;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> raw = prefs.getStringList('wellbeing_entries') ?? [];

      final entry = WellbeingEntry(
        date: DateTime.now(),
        sleepQuality: _sleep,
        mood: _mood,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      raw.add(jsonEncode(entry.toJson()));
      await prefs.setStringList('wellbeing_entries', raw);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar registro de sono e humor.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sono e Humor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Como você dormiu na última noite?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '0 = Muito mal · 10 = Dormiu muito bem',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Slider(
              value: _sleep.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: _sleep.toString(),
              onChanged: (v) {
                setState(() {
                  _sleep = v.round();
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Como está seu humor hoje?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '0 = Muito triste/irritada · 10 = Muito bem/disposta',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Slider(
              value: _mood.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: _mood.toString(),
              onChanged: (v) {
                setState(() {
                  _mood = v.round();
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Observações (opcional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ex.: Acordei várias vezes, estou mais cansada hoje...',
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isSaving ? null : _saveEntry,
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Salvar registro'),
            ),
          ],
        ),
      ),
    );
  }
}


