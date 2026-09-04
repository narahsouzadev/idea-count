import 'package:flutter/material.dart';
// Manter o último valor
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/counter_button.dart';

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
  // Manter o último valor
  // Chave para identificar o valor no armazenamento interno
  static const String _counterKey = 'saved_counter_value';
  
  /// Valor inicial do contador.
  ///
  /// Conforme definido no produto, o contador começa sempre em zero.
  int _count = 0;

  /// Controla a escala visual do número para o efeito de impulso no clique.
  double _numberScale = 1.0;

  /// Controla o deslocamento vertical do número para o efeito de salto ao resetar.
  double _numberOffsetY = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Busca o valor salvo assim que a tela abre
  }

  /// Carrega o valor salvo no SharedPreferences.
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt(_counterKey) ?? 0;
    });
  }

  /// Salva o valor atual do contador.
  Future<void> _saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
  }

  /// Incrementa o contador em 1.
  void _increment() {
    setState(() {
      _count++;
    });
    _saveCounter(_count); // Salva o último valor
    _triggerScaleAnimation(1.08); // Impulso de ampliação (cresce)
  }

  /// Decrementa o contador em 1.
  ///
  /// O contador não permite valores negativos.
  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
      });
      _saveCounter(_count); // <-- Linha adicionada
      _triggerScaleAnimation(0.92); // Impulso de redução (encolhe)
    }
  }

/// Exibe um diálogo de confirmação para evitar que o usuário zere o contador por engano.
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
            // Cancela a ação e fecha a janela sem alterar o contador.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            // Confirma a ação, fecha o diálogo e aciona o reset.
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

  /// Reseta o valor do contador para zero e persiste a alteração no armazenamento.
  ///
  /// O botão de reset faz parte do design criado pelo Stitch.
  void _reset() {
    setState(() {
      _count = 0;
    });
    _saveCounter(0);
    _triggerResetJumpAnimation(); // Dispara o salto vertical do número
  }

  /// Dispara a animação de escala temporária no número.
  void _triggerScaleAnimation(double targetScale) {
    setState(() {
      _numberScale = targetScale;
    });

    // Retorna a escala para o tamanho normal (1.0) após 100 milissegundos
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _numberScale = 1.0;
        });
      }
    });
  }

  /// Dispara a animação de salto vertical no número ao zerar o contador.
  void _triggerResetJumpAnimation() {
    setState(() {
      _numberOffsetY = -20.0; // Desloca o número para cima em 20 pixels
    });

    // Retorna o número para a posição original após 150 milissegundos
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _numberOffsetY = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho da aplicação.
            //
            // Mantido simples para seguir a proposta minimalista.
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

            // Área central contendo o número do contador.
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(0, _numberOffsetY, 0),
                  child: AnimatedScale(
                    scale: _numberScale,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    child: Text(
                      '$_count',

                      // O número é o elemento principal da interface.
                      style: const TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -4,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Área inferior dos controles.
            Padding(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  // Botões principais + e -.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CounterButton(
                        icon: Icons.remove,
                        onPressed: _decrement,
                      ),

                      const SizedBox(width: 32),

                      CounterButton(
                        icon: Icons.add,
                        onPressed: _increment,
                        isPrimary: true, // <-- Ativa a cor amarela
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Botão secundário de reset.
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