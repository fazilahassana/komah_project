import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:komah_project/models/complaint_order_summary.dart';
import 'package:komah_project/screens/complaint_form_page.dart';

void main() {
  const order = ComplaintOrderSummary(
    orderId: '#KM240625001',
    dateTimeLabel: '10 Juni 2026 · 14.30',
    pickup: 'Fakultas Teknik',
    destination: 'Perpustakaan Pusat',
  );

  Future<void> pumpComplaintForm(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ComplaintFormPage(order: order)),
    );
  }

  testWidgets('empty form shows both validation messages', (tester) async {
    await pumpComplaintForm(tester);

    expect(find.text('1 dari 4'), findsOneWidget);
    expect(find.text('Pesanan #KM240625001'), findsOneWidget);

    await tester.ensureVisible(find.text('Kirim Komplain'));
    await tester.tap(find.text('Kirim Komplain'));
    await tester.pumpAndSettle();

    expect(find.text('Kategori komplain wajib dipilih'), findsOneWidget);
    expect(find.text('Deskripsi komplain wajib diisi'), findsOneWidget);
    expect(find.text('1 dari 4'), findsOneWidget);
  });

  testWidgets('category without description shows description error', (
    tester,
  ) async {
    await pumpComplaintForm(tester);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Driver').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Kirim Komplain'));
    await tester.tap(find.text('Kirim Komplain'));
    await tester.pumpAndSettle();

    expect(find.text('Kategori komplain wajib dipilih'), findsNothing);
    expect(find.text('Deskripsi komplain wajib diisi'), findsOneWidget);
  });

  testWidgets('description without category shows category error', (
    tester,
  ) async {
    await pumpComplaintForm(tester);

    await tester.enterText(find.byType(TextFormField), 'Kendala pada pesanan.');
    await tester.ensureVisible(find.text('Kirim Komplain'));
    await tester.tap(find.text('Kirim Komplain'));
    await tester.pumpAndSettle();

    expect(find.text('Kategori komplain wajib dipilih'), findsOneWidget);
    expect(find.text('Deskripsi komplain wajib diisi'), findsNothing);
  });

  testWidgets('valid category and description pass validation without photo', (
    tester,
  ) async {
    await pumpComplaintForm(tester);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Driver').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Kendala pada pesanan.');
    await tester.ensureVisible(find.text('Kirim Komplain'));
    await tester.tap(find.text('Kirim Komplain'));
    await tester.pump();

    expect(find.text('Kategori komplain wajib dipilih'), findsNothing);
    expect(find.text('Deskripsi komplain wajib diisi'), findsNothing);
    expect(find.text('3 dari 4'), findsOneWidget);
    expect(find.text('Mengirim Komplain...'), findsNWidgets(2));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Kirim Komplain'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Mengirim Komplain...'),
          )
          .onPressed,
      isNull,
    );
    expect(
      find.text('Fitur foto bukti akan ditambahkan pada tahap berikutnya.'),
      findsNothing,
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Mengirim Komplain...'), findsNothing);
    expect(find.text('Komplain Berhasil Dikirim'), findsNothing);
    expect(find.text('2 dari 4'), findsOneWidget);
  });
}
