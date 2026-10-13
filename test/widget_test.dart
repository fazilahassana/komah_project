
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:komah_project/main.dart';
import 'package:komah_project/data/address_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('KOMAH app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final addressRepo = AddressRepository();
    await addressRepo.load();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AddressRepository>.value(
            value: addressRepo,
          ),
          ChangeNotifierProvider<AddressFormController>(
            create: (_) => AddressFormController(),
          ),
        ],
        child: const KomahApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Alamat Favorit'), findsOneWidget);
  });
}
