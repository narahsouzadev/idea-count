import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Botão circular utilizado pelos controles do contador.
///
/// Este widget foi separado da tela principal para:
/// - evitar código repetido;
/// - facilitar ajustes visuais;
/// - permitir reutilização em outras partes do aplicativo no futuro.
class CounterButton extends StatelessWidget {
  /// Ícone exibido dentro do botão.
  final IconData icon;

  /// Função executada quando o usuário toca no botão.
  final VoidCallback onPressed;

  /// Define se o botão é a ação principal.
  ///
  /// O botão de adicionar (+) recebe destaque amarelo.
  /// O botão de remover (-) recebe uma cor secundária.
  final bool isPrimary;

  /// Construtor do botão.
  const CounterButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Tamanho dos botões.
      width: 110,
      height: 110,

      child: ElevatedButton(
        // Adiciona a resposta tátil suave ao toque antes de executar a ação
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },

        // Remove o preenchimento interno padrão do botão.
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,

          // Botão perfeitamente circular.
          shape: const CircleBorder(),

          // Define a cor conforme o tipo de ação.
          backgroundColor: isPrimary
              ? const Color(0xFFFFC107) // Amarelo Idea36 (botão +)
              : const Color(0xFFF5F5F5), // Cinza Claro (botão -)

          // Remove sombra forte para manter o estilo minimalista.
          elevation: 0,

          // Define o comportamento visual durante o toque.
          overlayColor: Colors.black12,
        ),

        child: Icon(
          icon,

          // Tamanho do símbolo + ou -.
          size: 36,

          // Cor do símbolo + ou -.
          color: const Color(0xFF5B4300),
        ),
      ),
    );
  }
}