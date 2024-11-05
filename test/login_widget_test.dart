import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsapp/screens/forgot_password_screen.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/screens/register_screen.dart';


void main() {
  testWidgets('LoginScreen renders correctly and responds to input and tap', (WidgetTester tester) async {

    await tester.pumpWidget(const CupertinoApp(home: LoginScreen()));

  
  
    expect(find.text('Login'), findsOneWidget);


    final loginField = find.bySemanticsLabel('E-mail or Username');
    final passwordField = find.bySemanticsLabel('Password');
    expect(loginField, findsOneWidget);
    expect(passwordField, findsOneWidget);


    await tester.enterText(loginField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    
    
  
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    
    final signInButton = find.text('Sign in');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);

  
    await tester.pump();


  });

  testWidgets('Forgot password button navigates to ForgotPasswordScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const CupertinoApp(home: LoginScreen()));


    final forgotPasswordButton = find.text('Forgot password?');
    expect(forgotPasswordButton, findsOneWidget);
    await tester.tap(forgotPasswordButton);


    await tester.pumpAndSettle();


    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
  });

  testWidgets('Sign up button navigates to RegisterScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const CupertinoApp(home: LoginScreen()));

    final signUpButton = find.text('Sign up');
    expect(signUpButton, findsOneWidget);
    await tester.tap(signUpButton);

    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });
}
