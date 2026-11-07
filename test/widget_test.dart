import 'package:flutter_test/flutter_test.dart';
import 'package:studi_kasus2/main.dart';

void main() {
  testWidgets('Portfolio app berjalan', (WidgetTester tester) async {
    await tester.pumpWidget(const MyPortfolioApp());

    expect(find.text('Beranda'), findsOneWidget);
  });
}