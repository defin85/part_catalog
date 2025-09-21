import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdaptiveFormLayout Widget Tests', () {
    late List<Widget> testFields;

    setUp(() {
      testFields = [
        const TextField(decoration: InputDecoration(labelText: 'Field 1')),
        const TextField(decoration: InputDecoration(labelText: 'Field 2')),
        const TextField(decoration: InputDecoration(labelText: 'Field 3')),
        const TextField(decoration: InputDecoration(labelText: 'Field 4')),
        const TextField(decoration: InputDecoration(labelText: 'Field 5')),
        const TextField(decoration: InputDecoration(labelText: 'Field 6')),
      ];
    });

    testWidgets('should render basic form layout without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          AdaptiveFormLayout(
            fields: testFields,
          ),
        ),
      );

      expect(find.byType(AdaptiveFormLayout), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('should adapt to screen sizes with different column layouts', (tester) async {
      await AdaptiveTestHelpers.expectDifferentLayouts(
        tester,
        () => AdaptiveFormLayout(
          fields: testFields.take(4).toList(),
        ),
        smallScreenAssertions: () {
          // Mobile: Single column (Column layout)
          expect(find.byType(Column), findsOneWidget);
          expect(find.byType(Wrap), findsNothing);
        },
        mediumScreenAssertions: () {
          // Tablet: Two columns (Wrap layout)
          expect(find.byType(Wrap), findsOneWidget);
          expect(find.byType(Column), findsNothing);
        },
        largeScreenAssertions: () {
          // Desktop: Three columns (Wrap layout)
          expect(find.byType(Wrap), findsOneWidget);
          expect(find.byType(Column), findsNothing);
        },
      );
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => AdaptiveFormLayout(
          fields: List.generate(
            12,
            (index) => TextField(
              decoration: InputDecoration(
                labelText: 'Very Long Field Label That Might Cause Overflow $index',
              ),
            ),
          ),
        ),
      );
    });

    group('Column Layouts', () {
      testWidgets('should show single column on small screens', (tester) async {
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.smallScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: testFields,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should use Column layout
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Wrap), findsNothing);

        // All fields should be visible
        expect(find.byType(TextField), findsNWidgets(6));
      });

      testWidgets('should show two columns on medium screens', (tester) async {
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.mediumScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: testFields.take(4).toList(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should use Wrap layout for two columns
        expect(find.byType(Wrap), findsOneWidget);
        expect(find.byType(Column), findsNothing);

        // All fields should be visible with constrained width
        expect(find.byType(SizedBox), findsNWidgets(4));
        expect(find.byType(TextField), findsNWidgets(4));
      });

      testWidgets('should show three columns on large screens', (tester) async {
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: testFields,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should use Wrap layout for three columns
        expect(find.byType(Wrap), findsOneWidget);
        expect(find.byType(Column), findsNothing);

        // All fields should be visible with constrained width
        expect(find.byType(SizedBox), findsNWidgets(6));
        expect(find.byType(TextField), findsNWidgets(6));
      });
    });

    group('Field Width Calculations', () {
      testWidgets('should calculate correct field widths for two columns', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: [
                const TextField(decoration: InputDecoration(labelText: 'Test')),
              ],
              spacing: 16.0,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        // Expected width: (800 - 16) / 2 = 392
        expect(sizedBox.width, equals(392.0));
      });

      testWidgets('should calculate correct field widths for three columns', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: [
                const TextField(decoration: InputDecoration(labelText: 'Test')),
              ],
              spacing: 20.0,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        // Expected width: (1200 - (20 * 2)) / 3 = 386.67
        expect(sizedBox.width, closeTo(386.67, 0.1));
      });
    });

    group('Spacing Configuration', () {
      testWidgets('should apply custom spacing correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: testFields.take(3).toList(),
            spacing: 24.0,
            runSpacing: 32.0,
          ),
          description: 'custom spacing',
        );
      });

      testWidgets('should use default spacing when not specified', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: testFields.take(3).toList(),
          ),
          description: 'default spacing',
        );
      });
    });

    group('Padding Configuration', () {
      testWidgets('should apply custom padding correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: testFields.take(3).toList(),
            padding: const EdgeInsets.all(24.0),
          ),
          description: 'custom padding',
        );
      });

      testWidgets('should use zero padding when not specified', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: [const TextField()],
            ),
          ),
        );

        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, equals(EdgeInsets.zero));
      });
    });

    group('Field Count Variations', () {
      testWidgets('should handle single field correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: [const TextField(decoration: InputDecoration(labelText: 'Single'))],
          ),
          description: 'single field',
        );
      });

      testWidgets('should handle many fields correctly', (tester) async {
        final manyFields = List.generate(
          20,
          (index) => TextField(
            decoration: InputDecoration(labelText: 'Field ${index + 1}'),
          ),
        );

        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(fields: manyFields),
          description: 'many fields',
        );
      });
    });

    group('Breakpoint Behavior', () {
      testWidgets('should respect custom breakpoints', (tester) async {
        await AdaptiveTestHelpers.testBreakpoints(
          tester,
          () => AdaptiveFormLayout(
            fields: testFields.take(4).toList(),
          ),
        );
      });

      testWidgets('should transition layouts at exact breakpoints', (tester) async {
        // Test just below medium breakpoint (600px)
        await tester.binding.setSurfaceSize(const Size(599, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(fields: testFields.take(2).toList()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Column), findsOneWidget); // Single column

        // Test at medium breakpoint (600px)
        await tester.binding.setSurfaceSize(const Size(600, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(fields: testFields.take(2).toList()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Wrap), findsOneWidget); // Two columns

        // Test just below large breakpoint (1000px)
        await tester.binding.setSurfaceSize(const Size(999, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(fields: testFields.take(2).toList()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Wrap), findsOneWidget); // Two columns

        // Test at large breakpoint (1000px)
        await tester.binding.setSurfaceSize(const Size(1000, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(fields: testFields.take(2).toList()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Wrap), findsOneWidget); // Three columns
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => AdaptiveFormLayout(
          fields: testFields.take(4).toList(),
        ),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly with many fields', (tester) async {
        final manyFields = List.generate(
          50,
          (index) => TextField(
            decoration: InputDecoration(labelText: 'Performance Field $index'),
          ),
        );

        await TestHelpers.testPerformance(
          tester,
          AdaptiveFormLayout(fields: manyFields),
          maxRenderTimeMs: 200,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty fields list', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveFormLayout(fields: []),
          description: 'empty fields list',
        );
      });

      testWidgets('should handle very narrow screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(200, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: [const TextField(decoration: InputDecoration(labelText: 'Narrow'))],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdaptiveFormLayout), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very wide screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(4000, 800));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveFormLayout(
              fields: testFields.take(3).toList(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdaptiveFormLayout), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle zero spacing', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: testFields.take(3).toList(),
            spacing: 0.0,
            runSpacing: 0.0,
          ),
          description: 'zero spacing',
        );
      });

      testWidgets('should handle very large spacing', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: testFields.take(2).toList(),
            spacing: 100.0,
            runSpacing: 100.0,
          ),
          description: 'large spacing',
        );
      });
    });

    group('Complex Field Types', () {
      testWidgets('should handle different widget types as fields', (tester) async {
        final complexFields = [
          const TextField(decoration: InputDecoration(labelText: 'Text Field')),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Dropdown'),
            items: const [
              DropdownMenuItem(value: 'item1', child: Text('Item 1')),
              DropdownMenuItem(value: 'item2', child: Text('Item 2')),
            ],
            onChanged: (value) {},
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button Field'),
          ),
          const Checkbox(value: false, onChanged: null),
        ];

        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(fields: complexFields),
          description: 'complex field types',
        );
      });
    });

    group('Accessibility', () {
      testWidgets('should maintain accessibility on all screen sizes', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveFormLayout(
            fields: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Accessible Field',
                  helperText: 'Helper text for accessibility',
                ),
              ),
            ],
          ),
          description: 'accessibility',
        );
      });
    });
  });

  group('FullWidthField Widget Tests', () {
    testWidgets('should render and take full width', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          const FullWidthField(
            child: Text('Full Width Content'),
          ),
        ),
      );

      expect(find.byType(FullWidthField), findsOneWidget);
      expect(find.text('Full Width Content'), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(double.infinity));
    });

    testWidgets('should work within AdaptiveFormLayout', (tester) async {
      await AdaptiveTestHelpers.testAllScreenSizes(
        tester,
        () => AdaptiveFormLayout(
          fields: [
            const TextField(decoration: InputDecoration(labelText: 'Regular Field')),
            const FullWidthField(
              child: TextField(decoration: InputDecoration(labelText: 'Full Width Field')),
            ),
            const TextField(decoration: InputDecoration(labelText: 'Another Regular Field')),
          ],
        ),
        description: 'FullWidthField within AdaptiveFormLayout',
      );
    });

    testWidgets('should handle different child widgets', (tester) async {
      final widgets = [
        const Text('Text Widget'),
        ElevatedButton(onPressed: () {}, child: const Text('Button')),
        const Card(child: Text('Card Content')),
        Container(
          height: 100,
          color: Colors.blue,
          child: const Center(child: Text('Container')),
        ),
      ];

      for (final widget in widgets) {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            FullWidthField(child: widget),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(FullWidthField), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });
}