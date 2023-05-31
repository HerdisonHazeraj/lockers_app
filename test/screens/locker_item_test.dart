import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/screens/lockers/locker_item.dart';

main() {
    testWidgets('test the route of the locker', (tester) async {
    await tester.pumpWidget(LockerItem(Locker.base()));

    await tester.tap(find.widgetWithText(ListTile, 'Ajouter un casier'));

    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}