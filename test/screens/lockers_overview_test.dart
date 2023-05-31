import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockers_app/screens/lockers/lockers_overview_screen.dart';

main() {
  testWidgets('test the add of a locker', (tester) async {
    await tester.pumpWidget(const LockersOverviewScreen());

    await tester.tap(find.widgetWithText(ListTile, 'Ajouter un casier'));

    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
