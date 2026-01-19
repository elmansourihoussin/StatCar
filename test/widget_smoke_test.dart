import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:statcar/core/localization.dart';
import 'package:statcar/presentation/providers.dart';
import 'package:statcar/presentation/screens/fuel_list_screen.dart';

void main() {
  testWidgets('Fuel list empty state renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleIdProvider.overrideWith((ref) => StateController(1)),
          fuelEntriesProvider.overrideWith(
            (ref, _) => Future.value(const []),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [AppLocalizations.delegate],
          supportedLocales: [Locale('de')],
          home: FuelListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Noch keine Tankfüllungen.'), findsOneWidget);
  });
}
