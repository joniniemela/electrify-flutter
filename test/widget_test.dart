import 'package:electrify_flutter/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen renders on initial route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ElectrifyApp()));
    await tester.pumpAndSettle();

    // The router boots at /login, which renders the LoginScreen.
    expect(find.text('Tervetuloa Electrifyyn'), findsOneWidget);
    expect(find.text('Kirjaudu sisään'), findsWidgets);
  });
}
