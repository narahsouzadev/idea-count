import 'package:flutter/material.dart';

/// Widget responsável por exibir o número do contador e gerenciar suas próprias animações.
///
/// Isolar este widget garante que apenas o texto seja reconstruído (rebuild)
/// durante as animações, poupando a [CounterPage] de reconstruções desnecessárias.
class CounterDisplay extends StatefulWidget {
  /// Valor atual do contador a ser renderizado.
  final int count;

  const CounterDisplay({super.key, required this.count});

  @override
  State<CounterDisplay> createState() => _CounterDisplayState();
}

class _CounterDisplayState extends State<CounterDisplay>
    with TickerProviderStateMixin {
  /// Controlador responsável pela animação de crescimento/encolhimento (+ e -).
  late final AnimationController _scaleController;

  /// Controlador responsável pela animação de pulo (reset).
  late final AnimationController _jumpController;

  /// Define se a escala alvo será maior (incremento) ou menor (decremento).
  double _scaleTarget = 1.08;

  @override
  void initState() {
    super.initState();
    // Inicialização dos controladores com durações curtas para efeito de "impulso"
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  /// Observa mudanças na propriedade [count] vindas do widget pai.
  /// Dispara a animação correta dependendo da mudança de estado.
  @override
  void didUpdateWidget(CounterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Só anima se o valor realmente mudou
    if (widget.count != oldWidget.count) {
      if (widget.count == 0 && oldWidget.count != 0) {
        _triggerJump(); // Dispara o pulo ao zerar
      } else {
        _triggerScale(widget.count > oldWidget.count); // Cresce ou encolhe
      }
    }
  }

  /// Executa o ciclo de ir e voltar da animação de escala.
  Future<void> _triggerScale(bool isIncrement) async {
    _scaleTarget = isIncrement ? 1.08 : 0.92;
    await _scaleController.forward(from: 0.0);

    // Checagem obrigatória de ciclo de vida antes da reversão assíncrona
    if (!mounted) return;
    _scaleController.reverse();
  }

  /// Executa o ciclo de ir e voltar da animação de pulo.
  Future<void> _triggerJump() async {
    await _jumpController.forward(from: 0.0);

    if (!mounted) return;
    _jumpController.reverse();
  }

  /// Libera os recursos da GPU descartando os Tickers ao desmontar o widget.
  @override
  void dispose() {
    _scaleController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // O AnimatedBuilder reconstrói apenas o Transform em sincronia com os frames da animação
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _jumpController]),
      builder: (context, child) {
        // Interpola a escala e o deslocamento Y baseando-se no valor atual dos controladores
        final scale =
            1.0 +
            (_scaleTarget - 1.0) *
                Curves.easeOut.transform(_scaleController.value);
        final offsetY = -20.0 * Curves.easeOut.transform(_jumpController.value);

        return Transform.translate(
          offset: Offset(0.0, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      // O Text estático é passado como child para não ser reconstruído a cada frame da animação
      child: Text(
        '${widget.count}',
        style: const TextStyle(
          fontSize: 120,
          fontWeight: FontWeight.w700,
          letterSpacing: -4,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
