import 'package:flutter_test/flutter_test.dart';
import 'package:sportzon/main.dart';

void main() {
  testWidgets('SPORTZON app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SportzonApp());
    expect(find.text('SPORTZON'), findsWidgets);
  });
}
