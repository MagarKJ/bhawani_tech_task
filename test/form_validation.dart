import 'package:bhawani_tech_task/presentation/dashboard/add_expense_page.dart';
import 'package:bhawani_tech_task/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Validate required fields when submitting form',
      (WidgetTester tester) async {
    // Arrange:
    // Set up the widget under test by wrapping the AddExpenseScreen inside a BlocProvider
    // that provides the DashboardBloc. This ensures that the widget has access to
    // the necessary bloc for state management during the test.
    await tester.pumpWidget(
      BlocProvider<DashboardBloc>(
        create: (_) => DashboardBloc(), // Create the DashboardBloc instance
        child: GetMaterialApp(
          // Wrap the widget in a MaterialApp for proper theming and context
          home:
              AddExpenseScreen(), // Replace with your screen/widget that uses the DashboardBloc
        ),
      ),
    );

    // Act:
    // Simulate a user action where the submit button is tapped without filling any fields
    final submitButton =
        find.byKey(Key('Submit')); // Find the submit button by its Key
    await tester.tap(submitButton); // Perform a tap action on the submit button
    await tester.pump(); // Rebuild the widget tree after the tap

    // Assert:
    // After the tap, check for the presence of error messages related to required fields
    // This will ensure that the form validation is working as expected.
    expect(find.text('Please enter a title'),
        findsOneWidget); // Check if the title error message is displayed
    expect(find.text('Please enter an amount'),
        findsOneWidget); // Check if the amount error message is displayed
    expect(find.text('Please enter a description'),
        findsOneWidget); // Check if the description error message is displayed
  });
}
