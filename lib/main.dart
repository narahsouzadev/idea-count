import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. IMPORTANTE: Import necessário para o SystemChrome

import 'pages/counter_page.dart';
import 'theme/app_theme.dart';

/// Ponto de entrada da aplicação.
///
/// Toda aplicação Flutter inicia sua execução por esta função.
/// Ela é responsável por iniciar o widget principal do aplicativo.
void main() async { // 2. Adicionado 'async' para aguardar as configurações do sistema
  // Garante a inicialização das ligações do Flutter com a plataforma nativa
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Bloqueia a orientação do aplicativo exclusivamente para Modo Retrato (Portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const IdeaCountApp());
}

/// Widget raiz da aplicação.
///
/// Sua única responsabilidade é configurar o aplicativo:
/// - nome;
/// - tema global;
/// - tela inicial.
///
/// Nenhuma regra de negócio deve ficar aqui.
class IdeaCountApp extends StatelessWidget {
  /// Construtor padrão.
  const IdeaCountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove a faixa "DEBUG" exibida durante o desenvolvimento.
      debugShowCheckedModeBanner: false,

      // Nome da aplicação.
      title: 'Idea Count',

      // Tema global da aplicação.
      //
      // Toda configuração visual (cores, tipografia e estilos)
      // ficará centralizada em app_theme.dart.
      theme: AppTheme.lightTheme,

      // Primeira tela exibida ao iniciar o aplicativo.
      home: const CounterPage(),
    );
  }
}