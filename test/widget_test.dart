import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:market/main.dart';
import 'package:provider/provider.dart';
import 'package:market/providers/ThemeProvider.dart';
import 'package:market/providers/AuthProvider.dart';
import 'package:market/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(SharedPreferences.getInstance())),
          ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ],
        child: const MyApp(),
      ),
    );
    
    // Verify that the app renders without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
