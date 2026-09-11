import 'package:flutter/material.dart';
import '../widgets/counter_button.dart';
import '../widgets/counter_display.dart';
import '../services/counter_storage_service.dart';

/// Tela principal do Idea Count.
///
/// Responsável por:
/// - exibir o valor atual do contador;
/// - controlar o estado do contador;
/// - organizar os elementos visuais da tela.
///
/// Como o aplicativo é simples, o gerenciamento de estado será feito
/// utilizando StatefulWidget + setState().
class CounterPage extends StatefulWidget {
  /// Construtor padrão da tela.
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

/// Estado interno da CounterPage.
///
/// Guarda o valor atual do contador e atualiza a interface
/// sempre que esse valor mudar.
class _CounterPageState extends State<CounterPage> {
  final CounterStorageService _storageService = CounterStorageService();
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final value = await _storageService.loadCounter();
    if (!mounted) return;
    setState(() {
      _count = value;
    });
  }

  Future<void> _saveCounter(int value) async {
    await _storageService.saveCounter(value);
  }

  void _increment() {
    setState(() => _count++);
    _saveCounter(_count);
  }

  void _decrement() {
    if (_count > 0) {
      setState(() => _count--);
      _saveCounter(_count);
    }
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Zerar contador?'),
          content: const Text(
            'Esta ação irá redefinir a sua contagem atual para zero. Deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reset();
              },
              child: const Text(
                'Zerar',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _reset() {
    setState(() => _count = 0);
    _saveCounter(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'IDEA COUNT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            Expanded(
              child: Center(child: CounterDisplay(count: _count)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CounterButton(icon: Icons.remove, onPressed: _decrement),
                      const SizedBox(width: 32),
                      CounterButton(
                        icon: Icons.add,
                        onPressed: _increment,
                        isPrimary: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showResetConfirmationDialog,
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(120, 30),
                      side: const BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'RESET COUNT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF5B4300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
