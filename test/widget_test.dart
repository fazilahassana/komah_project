import 'package:flutter_test/flutter_test.dart';

import 'package:komah_project/main.dart';

void main() {
  testWidgets('KOMAH app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KomahApp());

    // Verify Landing Page renders with headline text.
    expect(find.textContaining('Anter'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsOneWidget);
  });
}
