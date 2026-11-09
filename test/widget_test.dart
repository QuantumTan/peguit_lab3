import 'package:flutter_test/flutter_test.dart';
import 'package:peguit_lab3/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LoginRegisterApp());
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
