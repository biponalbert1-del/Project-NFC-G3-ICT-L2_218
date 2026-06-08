import 'package:flutter_test/flutter_test.dart';
import 'package:token_transfer_app/main.dart';

void main() {
  testWidgets('application starts', (tester) async {
    await tester.pumpWidget(const TokenTransferApp());
    expect(find.text('JETONS-TRANSFERT'), findsOneWidget);
  });
}
