import 'package:flutter/material.dart';

/// Centraliza todas as configurações visuais do aplicativo.
///
/// Manter o tema em um arquivo separado evita espalhar cores,
/// estilos e configurações visuais pelo projeto.
///
/// Dessa forma, futuras alterações na identidade visual da
/// Idea36 Labs podem ser feitas em um único lugar.
class AppTheme {
  /// Tema principal da aplicação.
  ///
  /// Atualmente o Idea Count possui apenas uma versão clara,
  /// seguindo a proposta de:
  /// - fundo branco;
  /// - alto contraste;
  /// - amarelo Idea36 como cor de ação.
  static ThemeData get lightTheme {
    return ThemeData(
      // Utiliza Material 3, padrão atual do Flutter.
      useMaterial3: true,

      // Cor base utilizada pelo sistema de componentes.
      //
      // O amarelo representa a identidade visual da Idea36 Labs.
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFC107),
        brightness: Brightness.light,
      ),

      // Cor padrão do fundo das telas.
      scaffoldBackgroundColor: Colors.white,

      // Configuração global dos textos.
      textTheme: const TextTheme(
        // Estilo usado futuramente para o número principal.
        //
        // O contador terá um tamanho maior definido no widget
        // específico, mas esta configuração estabelece a base.
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),

        // Estilo para textos menores, como títulos e botões.
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF1A1A1A),
        ),
      ),

      // Configuração padrão dos botões elevados.
      //
      // Os botões personalizados do contador terão estilos próprios,
      // mas esta configuração mantém consistência com o Material 3.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
        ),
      ),
    );
  }
}