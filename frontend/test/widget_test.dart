import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Allow any animations or layout passes to complete
    await tester.pumpAndSettle();

    // Verify AuditSense text appears (Case-insensitive)
    expect(find.textContaining('AuditSense', findRichText: true), findsAtLeast(1));
  });
}
