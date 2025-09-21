import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/adaptive_text.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdaptiveText Widget Tests', () {
    testWidgets('should render basic text without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          const AdaptiveText('Test Text'),
        ),
      );

      expect(find.byType(AdaptiveText), findsOneWidget);
      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should adapt to screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => const AdaptiveText('Adaptive Text'),
        assertions: (screenSize) {
          expect(find.byType(AdaptiveText), findsOneWidget);
          expect(find.text('Adaptive Text'), findsOneWidget);
        },
      );
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => const AdaptiveText('Very long text content that might cause overflow'),
      );
    });

    group('Text Styles', () {
      for (final style in AdaptiveTextStyle.values) {
        testWidgets('should render ${style.name} style correctly', (tester) async {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveText(
              '${style.name} text',
              textStyle: style,
            ),
            description: '${style.name} text style',
          );
        });
      }
    });

    group('Scaling Modes', () {
      for (final mode in TextScalingMode.values) {
        testWidgets('should handle ${mode.name} scaling mode', (tester) async {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveText(
              '${mode.name} scaling',
              scalingMode: mode,
            ),
            description: '${mode.name} scaling mode',
          );
        });
      }
    });

    group('Named Constructors', () {
      testWidgets('should work with .headline constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText.headline('Headline Text'),
          description: 'headline constructor',
        );
      });

      testWidgets('should work with .subheadline constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText.subheadline('Subheadline Text'),
          description: 'subheadline constructor',
        );
      });

      testWidgets('should work with .body constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText.body('Body Text'),
          description: 'body constructor',
        );
      });

      testWidgets('should work with .bodySecondary constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText.bodySecondary('Body Secondary Text'),
          description: 'bodySecondary constructor',
        );
      });

      testWidgets('should work with .caption constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText.caption('Caption Text'),
          description: 'caption constructor',
        );
      });
    });

    group('Font Size Adaptation', () {
      testWidgets('should have different font sizes on different screens', (tester) async {
        await AdaptiveTestHelpers.expectAdaptiveTextSizes(
          tester,
          () => const AdaptiveText.headline('Size Test'),
        );
      });

      testWidgets('should respect custom text config', (tester) async {
        const customConfig = AdaptiveTextConfig(
          mobileSize: 12,
          tabletSize: 16,
          desktopSize: 20,
        );

        double? smallFontSize, mediumFontSize, largeFontSize;

        // Small screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.smallScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveText(
              'Custom Config',
              config: customConfig,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final smallText = tester.widget<Text>(find.byType(Text));
        smallFontSize = smallText.style?.fontSize;

        // Large screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveText(
              'Custom Config',
              config: customConfig,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final largeText = tester.widget<Text>(find.byType(Text));
        largeFontSize = largeText.style?.fontSize;

        // Verify different sizes
        expect(smallFontSize, isNotNull);
        expect(largeFontSize, isNotNull);
        if (smallFontSize != null && largeFontSize != null) {
          expect(largeFontSize > smallFontSize, isTrue,
              reason: 'Large screen should have larger font size');
        }
      });
    });

    group('Extension Methods', () {
      testWidgets('should work with asAdaptiveHeadline extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => 'Extension Test'.asAdaptiveHeadline(),
          description: 'asAdaptiveHeadline extension',
        );
      });

      testWidgets('should work with asAdaptiveSubheadline extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => 'Extension Test'.asAdaptiveSubheadline(),
          description: 'asAdaptiveSubheadline extension',
        );
      });

      testWidgets('should work with asAdaptiveBody extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => 'Extension Test'.asAdaptiveBody(),
          description: 'asAdaptiveBody extension',
        );
      });

      testWidgets('should work with asAdaptiveBodySecondary extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => 'Extension Test'.asAdaptiveBodySecondary(),
          description: 'asAdaptiveBodySecondary extension',
        );
      });

      testWidgets('should work with asAdaptiveCaption extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => 'Extension Test'.asAdaptiveCaption(),
          description: 'asAdaptiveCaption extension',
        );
      });
    });

    group('Text Properties', () {
      testWidgets('should handle text overflow correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'Very long text that might overflow in small containers',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          description: 'text overflow',
        );
      });

      testWidgets('should handle text alignment', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'Centered Text',
            textAlign: TextAlign.center,
          ),
          description: 'text alignment',
        );
      });

      testWidgets('should apply custom colors and weights', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'Styled Text',
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          description: 'styled text',
        );
      });
    });

    group('Automatic Scaling', () {
      testWidgets('should auto-fit text when scaling mode is automatic', (tester) async {
        await tester.binding.setSurfaceSize(const Size(200, 100));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Container(
              width: 100,
              height: 50,
              child: const AdaptiveText(
                'Long text that should auto-fit',
                scalingMode: TextScalingMode.automatic,
                config: AdaptiveTextConfig(
                  adaptToWidth: true,
                  maxFontScale: 2.0,
                  minFontScale: 0.5,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdaptiveText), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility Scaling', () {
      testWidgets('should respect accessibility text scaling', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(1.5),
              ),
              child: const AdaptiveText(
                'Accessible Text',
                scalingMode: TextScalingMode.accessibility,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdaptiveText), findsOneWidget);
        expect(find.text('Accessible Text'), findsOneWidget);
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => const AdaptiveText('Breakpoint Test'),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly with long text', (tester) async {
        final longText = 'Long text content ' * 100;

        await TestHelpers.testPerformance(
          tester,
          AdaptiveText(longText),
          maxRenderTimeMs: 100,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty text', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(''),
          description: 'empty text',
        );
      });

      testWidgets('should handle null custom style gracefully', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'Text with null style',
            customStyle: null,
          ),
          description: 'null custom style',
        );
      });

      testWidgets('should handle very small font sizes', (tester) async {
        const config = AdaptiveTextConfig(
          mobileSize: 1,
          tabletSize: 2,
          desktopSize: 3,
        );

        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'Tiny Text',
            config: config,
          ),
          description: 'very small font sizes',
        );
      });

      testWidgets('should handle very large font sizes', (tester) async {
        const config = AdaptiveTextConfig(
          mobileSize: 50,
          tabletSize: 60,
          desktopSize: 72,
        );

        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'Huge',
            config: config,
          ),
          description: 'very large font sizes',
        );
      });
    });

    group('Multiline Text', () {
      testWidgets('should handle multiline text correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveText(
            'This is a very long text that should wrap to multiple lines on smaller screens',
            maxLines: 3,
          ),
          description: 'multiline text',
        );
      });
    });
  });
}