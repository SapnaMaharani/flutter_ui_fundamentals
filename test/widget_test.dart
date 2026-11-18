import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_fundamentals/main.dart';

void main() {
  test('CourseDataManagerApp dapat dibuat', () {
    const app = CourseDataManagerApp();

    expect(app, isA<CourseDataManagerApp>());
  });
}
