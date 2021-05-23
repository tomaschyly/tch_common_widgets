// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:tch_common_widgets/tch_common_widgets.dart';

// void main() {
//   const MethodChannel channel = MethodChannel('tch_common_widgets');

//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });

//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await TchCommonWidgets.platformVersion, '42');
//   });
// }
