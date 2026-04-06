import 'package:flutter_test/flutter_test.dart';

import 'package:tch_common_widgets_example/main.dart';

/// Run widget tests for the example app.
void main() {
  testWidgets('shows app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Plugin example app'), findsOneWidget);
  });
}
