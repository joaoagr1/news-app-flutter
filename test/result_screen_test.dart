import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/screens/result_screen.dart';
import 'package:newsapp/components/dialog/news_card.dart';
import 'package:newsapp/screens/news_detail_screen.dart';


class MockClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  group('ResultScreen', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    Future<void> _buildResultScreen(WidgetTester tester, User user) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResultScreen(token: 'dummy_token', user: user),
        ),
      );
    }

    testWidgets('exibe CircularProgressIndicator durante o carregamento', (WidgetTester tester) async {
      User user = User(
        id: '1',
        login: 'test_user',
        email: 'test@example.com',
        role: 'USER',
        document: '123456789',
        createdAt: '2024-01-01',
      );

      await _buildResultScreen(tester, user);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('exibe lista de NewsCards quando o carregamento é bem-sucedido', (WidgetTester tester) async {
      User user = User(
        id: '1',
        login: 'test_user',
        email: 'test@example.com',
        role: 'USER',
        document: '123456789',
        createdAt: '2024-01-01',
      );

      final newsJson = [
        {'id': 1, 'title': 'Notícia 1', 'content': 'Conteúdo da Notícia 1'},
        {'id': 2, 'title': 'Notícia 2', 'content': 'Conteúdo da Notícia 2'}
      ];
      final responseJson = jsonEncode(newsJson);

      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response(responseJson, 200));
      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response('Erro', 404));
      await _buildResultScreen(tester, user);
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsNWidgets(2));
      expect(find.text('Notícia 1'), findsOneWidget);
      expect(find.text('Notícia 2'), findsOneWidget);
    });

    testWidgets('não exibe CircularProgressIndicator após o carregamento das notícias', (WidgetTester tester) async {
      User user = User(
        id: '1',
        login: 'test_user',
        email: 'test@example.com',
        role: 'USER',
        document: '123456789',
        createdAt: '2024-01-01',
      );

      final newsJson = [
        {'id': 1, 'title': 'Notícia 1', 'content': 'Conteúdo da Notícia 1'}
      ];
      final responseJson = jsonEncode(newsJson);

      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response(responseJson, 200));
      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response('Erro', 404));
      await _buildResultScreen(tester, user);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('não exibe NewsCard se o carregamento falha', (WidgetTester tester) async {
      User user = User(
        id: '1',
        login: 'test_user',
        email: 'test@example.com',
        role: 'USER',
        document: '123456789',
        createdAt: '2024-01-01',
      );

      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response(responseJson, 200));
      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response('Erro', 404)); await _buildResultScreen(tester, user);
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsNothing);
      expect(find.text('Erro ao carregar notícias'), findsOneWidget); // Adicione uma mensagem de erro adequada se necessário
    });

    testWidgets('navegação para NewsDetailScreen quando um NewsCard é clicado', (WidgetTester tester) async {
      User user = User(
        id: '1',
        login: 'test_user',
        email: 'test@example.com',
        role: 'USER',
        document: '123456789',
        createdAt: '2024-01-01',
      );

      final newsJson = [
        {'id': 1, 'title': 'Notícia 1', 'content': 'Conteúdo da Notícia 1'}
      ];
      final responseJson = jsonEncode(newsJson);

      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response(responseJson, 200));
      when(mockClient.get(any as Uri)).thenAnswer((_) async => http.Response('Erro', 404));
      await _buildResultScreen(tester, user);
      await tester.pumpAndSettle();


      await tester.tap(find.byType(NewsCard).first);
      await tester.pumpAndSettle();


      expect(find.byType(NewsDetailScreen), findsOneWidget);
    });
  });
}
