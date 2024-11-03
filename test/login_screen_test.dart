import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/components/dialog/error_dialog.dart';
import 'package:newsapp/screens/forgot_password_screen.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/screens/register_screen.dart';
import 'package:newsapp/screens/result_screen.dart';

class MockClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  group('LoginScreen', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    Future<void> buildLoginScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        const CupertinoApp(
          home: LoginScreen(),
        ),
      );
    }

    testWidgets('navega para ForgotPasswordScreen ao clicar em "Forgot password?"', (WidgetTester tester) async {
      await buildLoginScreen(tester);

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('navega para RegisterScreen ao clicar em "Sign up"', (WidgetTester tester) async {
      await buildLoginScreen(tester);

      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets('exibe ResultScreen quando o login é bem-sucedido', (WidgetTester tester) async {
      final responseJson = jsonEncode({
        'token': 'mockToken',
        'users': {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com'
        }
      });
      when(mockClient.post(Uri.parse('https://example.com/login'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      await buildLoginScreen(tester);


      await tester.enterText(find.byType(CupertinoTextField).at(0), 'testUser');
      await tester.enterText(find.byType(CupertinoTextField).at(1), 'password123');

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('mockToken'), findsOneWidget); // Verifica o token na ResultScreen
    });

    testWidgets('exibe ErrorDialog quando o login falha', (WidgetTester tester) async {
      final errorResponse = jsonEncode({'error': 'Invalid credentials'});

      when(mockClient.post(Uri.parse('https://example.com/login'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(errorResponse, 401));

      await buildLoginScreen(tester);


      await tester.enterText(find.byType(CupertinoTextField).at(0), 'testUser');
      await tester.enterText(find.byType(CupertinoTextField).at(1), 'wrongPassword');

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorDialog), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('exibe ErrorDialog quando ocorre um erro de rede', (WidgetTester tester) async {
      when(mockClient.post(Uri.parse('https://example.com/login'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenThrow(Exception('Erro de conexão'));

      await buildLoginScreen(tester);


      await tester.enterText(find.byType(CupertinoTextField).at(0), 'testUser');
      await tester.enterText(find.byType(CupertinoTextField).at(1), 'password123');

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorDialog), findsOneWidget);
      expect(find.text('Erro ao conectar ao servidor. Tente novamente mais tarde.'), findsOneWidget);
    });
  });
}
