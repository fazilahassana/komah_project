import 'package:flutter_test/flutter_test.dart';

import 'package:komah_project/main.dart';

void main() {
  testWidgets('KOMAH payment proof flow advances through all steps', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KomahApp());
    await tester.pumpAndSettle();

    expect(find.text('Bukti Pembayaran'), findsOneWidget);
    expect(find.text('Rp 12.000'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsOneWidget);

    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();
    expect(find.text('Unggah Bukti Pembayaran'), findsOneWidget);
    expect(find.text('Pratinjau Foto'), findsOneWidget);

    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi Bukti Pembayaran'), findsOneWidget);

    await tester.tap(find.text('Konfirmasi Bukti Pembayaran'));
    await tester.pumpAndSettle();
    expect(find.text('Bukti Pembayaran Berhasil'), findsOneWidget);
    expect(find.text('ID Transaksi'), findsOneWidget);
  });
}
