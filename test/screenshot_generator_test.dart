import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peguit_lab3/main.dart';

void main() {
  testWidgets('Generate screenshots with real fonts',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Load actual fonts for clean screenshot generation
    final robotoLoader = FontLoader('Roboto')
      ..addFont(Future.value(File(
              r'C:\flutter\bin\cache\artifacts\material_fonts\roboto-regular.ttf')
          .readAsBytesSync()
          .buffer
          .asByteData()))
      ..addFont(Future.value(File(
              r'C:\flutter\bin\cache\artifacts\material_fonts\roboto-bold.ttf')
          .readAsBytesSync()
          .buffer
          .asByteData()))
      ..addFont(Future.value(File(
              r'C:\flutter\bin\cache\artifacts\material_fonts\roboto-medium.ttf')
          .readAsBytesSync()
          .buffer
          .asByteData()));
    await robotoLoader.load();

    final iconLoader = FontLoader('MaterialIcons')
      ..addFont(Future.value(File(
              r'C:\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf')
          .readAsBytesSync()
          .buffer
          .asByteData()));
    await iconLoader.load();

    final repaintKey = GlobalKey();

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: const LoginRegisterApp(),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> capture(String filename) async {
      await tester.runAsync(() async {
        final boundary = repaintKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('screenshots/$filename');
        file.writeAsBytesSync(byteData!.buffer.asUint8List());
      });
    }

    // 1. Login form screenshot
    await capture('login_form.png');

    // 2. Switch to Registration form
    await tester.tap(find.text('No account yet? Register'));
    await tester.pumpAndSettle();
    await capture('registration_form.png');

    // 3. Validation error screenshot (e.g. invalid email, short password, mismatch)
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'), 'Juan Dela Cruz');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'juan');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '12345');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'), 'different');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();
    await capture('validation_error.png');

    // Now fill valid credentials and register
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'juan@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'flutter123');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'), 'flutter123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    // Now login with registered account
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'juan@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'flutter123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 4. Welcome screen screenshot
    await capture('welcome_screen.png');
  });
}
