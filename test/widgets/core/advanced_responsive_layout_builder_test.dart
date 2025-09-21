import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/advanced_responsive_layout_builder.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdvancedResponsiveLayoutBuilder Widget Tests', () {
    testWidgets('should render basic layout without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          AdvancedResponsiveLayoutBuilder(
            fallback: (context, screenInfo) => const Text('Fallback Layout'),
            small: (context, screenInfo) => const Text('Small Layout'),
            medium: (context, screenInfo) => const Text('Medium Layout'),
            large: (context, screenInfo) => const Text('Large Layout'),
          ),
        ),
      );

      expect(find.byType(AdvancedResponsiveLayoutBuilder), findsOneWidget);
      expect(find.text('Small Layout'), findsOneWidget);
    });

    testWidgets('should switch layouts based on advanced screen sizes', (tester) async {
      Widget builder() => AdvancedResponsiveLayoutBuilder(
            tiny: (context, screenInfo) => const Text('Tiny Layout'),
            small: (context, screenInfo) => const Text('Small Layout'),
            medium: (context, screenInfo) => const Text('Medium Layout'),
            large: (context, screenInfo) => const Text('Large Layout'),
            extraLarge: (context, screenInfo) => const Text('Extra Large Layout'),
            desktop: (context, screenInfo) => const Text('Desktop Layout'),
            fallback: (context, screenInfo) => const Text('Fallback Layout'),
          );

      // Test tiny screen
      await tester.binding.setSurfaceSize(const Size(250, 400));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Tiny Layout'), findsOneWidget);

      // Test small screen
      await tester.binding.setSurfaceSize(const Size(500, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Small Layout'), findsOneWidget);

      // Test medium screen
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Medium Layout'), findsOneWidget);

      // Test large screen
      await tester.binding.setSurfaceSize(const Size(1100, 800));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Large Layout'), findsOneWidget);

      // Test extra large screen
      await tester.binding.setSurfaceSize(const Size(1500, 900));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Extra Large Layout'), findsOneWidget);

      // Test desktop screen
      await tester.binding.setSurfaceSize(const Size(2000, 1080));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Desktop Layout'), findsOneWidget);
    });

    testWidgets('should use fallback when specific layouts are not provided', (tester) async {
      Widget builder() => AdvancedResponsiveLayoutBuilder(
            fallback: (context, screenInfo) => Text('Fallback for ${screenInfo.size.name}'),
          );

      // Test various screen sizes - all should use fallback
      final testSizes = [
        const Size(250, 400), // tiny
        const Size(500, 600), // small
        const Size(800, 600), // medium
        const Size(1100, 800), // large
        const Size(1500, 900), // extra large
        const Size(2000, 1080), // desktop
      ];

      for (final size in testSizes) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.textContaining('Fallback for'), findsOneWidget);
      }
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => AdvancedResponsiveLayoutBuilder(
          fallback: (context, screenInfo) => Column(
            children: List.generate(
              10,
              (index) => Text('Item $index for ${screenInfo.size.name}'),
            ),
          ),
        ),
      );
    });

    group('Screen Size Detection', () {
      testWidgets('should detect tiny screens correctly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(250, 400));
        AdvancedScreenSize? detectedSize;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedSize = screenInfo.size;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedSize, equals(AdvancedScreenSize.tiny));
      });

      testWidgets('should detect desktop screens correctly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 1080));
        AdvancedScreenSize? detectedSize;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedSize = screenInfo.size;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedSize, equals(AdvancedScreenSize.desktop));
      });
    });

    group('Device Type Detection', () {
      testWidgets('should detect phone correctly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        DeviceType? detectedType;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedType = screenInfo.deviceType;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedType, equals(DeviceType.phone));
      });

      testWidgets('should detect tablet correctly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1000, 800));
        DeviceType? detectedType;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedType = screenInfo.deviceType;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedType, equals(DeviceType.tablet));
      });

      testWidgets('should detect desktop correctly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1800, 1080));
        DeviceType? detectedType;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedType = screenInfo.deviceType;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedType, equals(DeviceType.desktop));
      });

      testWidgets('should detect TV correctly', (tester) async {
        await tester.binding.setSurfaceSize(const Size(3840, 2160)); // 4K TV
        DeviceType? detectedType;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedType = screenInfo.deviceType;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedType, equals(DeviceType.tv));
      });
    });

    group('Orientation Detection', () {
      testWidgets('should detect portrait orientation', (tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        DeviceOrientation? detectedOrientation;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedOrientation = screenInfo.orientation;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedOrientation, equals(DeviceOrientation.portrait));
      });

      testWidgets('should detect landscape orientation', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 400));
        DeviceOrientation? detectedOrientation;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) {
                detectedOrientation = screenInfo.orientation;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedOrientation, equals(DeviceOrientation.landscape));
      });

      testWidgets('should detect foldable unfolded state', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 400)); // Very wide aspect ratio
        DeviceOrientation? detectedOrientation;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              detectFoldableDevices: true,
              fallback: (context, screenInfo) {
                detectedOrientation = screenInfo.orientation;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedOrientation, equals(DeviceOrientation.unfolded));
      });

      testWidgets('should detect foldable folded state', (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 400)); // Narrow folded device
        DeviceOrientation? detectedOrientation;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              detectFoldableDevices: true,
              fallback: (context, screenInfo) {
                detectedOrientation = screenInfo.orientation;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedOrientation, equals(DeviceOrientation.folded));
      });
    });

    group('Foldable Device Detection', () {
      testWidgets('should detect foldable device when enabled', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 400));
        DeviceType? detectedType;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              detectFoldableDevices: true,
              fallback: (context, screenInfo) {
                detectedType = screenInfo.deviceType;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedType, equals(DeviceType.foldable));
      });

      testWidgets('should not detect foldable device when disabled', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 400));
        DeviceType? detectedType;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              detectFoldableDevices: false,
              fallback: (context, screenInfo) {
                detectedType = screenInfo.deviceType;
                return const Text('Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(detectedType, isNot(DeviceType.foldable));
      });
    });

    group('Custom Breakpoints', () {
      testWidgets('should use custom breakpoints correctly', (tester) async {
        const customBreakpoints = ResponsiveBreakpoints(
          tinyBreakpoint: 200.0,
          smallBreakpoint: 400.0,
          mediumBreakpoint: 600.0,
          largeBreakpoint: 800.0,
          extraLargeBreakpoint: 1000.0,
          desktopBreakpoint: 1200.0,
        );

        AdvancedScreenSize? detectedSize;

        Widget builder() => AdvancedResponsiveLayoutBuilder(
              breakpoints: customBreakpoints,
              fallback: (context, screenInfo) {
                detectedSize = screenInfo.size;
                return Text('Custom ${screenInfo.size.name}');
              },
            );

        // Test custom medium breakpoint
        await tester.binding.setSurfaceSize(const Size(500, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(detectedSize, equals(AdvancedScreenSize.small));

        // Test custom large breakpoint
        await tester.binding.setSurfaceSize(const Size(700, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(detectedSize, equals(AdvancedScreenSize.medium));
      });

      testWidgets('should use foldable breakpoints correctly', (tester) async {
        AdvancedScreenSize? detectedSize;

        Widget builder() => AdvancedResponsiveLayoutBuilder(
              breakpoints: ResponsiveBreakpoints.foldable,
              fallback: (context, screenInfo) {
                detectedSize = screenInfo.size;
                return Text('Foldable ${screenInfo.size.name}');
              },
            );

        await tester.binding.setSurfaceSize(const Size(700, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();

        expect(detectedSize, equals(AdvancedScreenSize.medium));
      });

      testWidgets('should use adaptive breakpoints correctly', (tester) async {
        final adaptiveBreakpoints = ResponsiveBreakpoints.adaptive(
          contentWidth: 1200,
          columnCount: 4,
        );

        AdvancedScreenSize? detectedSize;

        Widget builder() => AdvancedResponsiveLayoutBuilder(
              breakpoints: adaptiveBreakpoints,
              fallback: (context, screenInfo) {
                detectedSize = screenInfo.size;
                return Text('Adaptive ${screenInfo.size.name}');
              },
            );

        await tester.binding.setSurfaceSize(const Size(500, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();

        expect(detectedSize, isNotNull);
      });
    });

    group('Builder Fallback Chain', () {
      testWidgets('should use fallback chain correctly', (tester) async {
        Widget builder() => AdvancedResponsiveLayoutBuilder(
              // Only provide small and fallback
              small: (context, screenInfo) => const Text('Small Available'),
              fallback: (context, screenInfo) => const Text('Fallback'),
            );

        // Test tiny screen - should use small (fallback chain: tiny -> small -> fallback)
        await tester.binding.setSurfaceSize(const Size(250, 400));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Small Available'), findsOneWidget);

        // Test medium screen - should use small (fallback chain: medium -> small -> fallback)
        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Small Available'), findsOneWidget);
      });

      testWidgets('should use fallback when no specific builder is available', (tester) async {
        Widget builder() => AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) => const Text('Only Fallback'),
            );

        await tester.binding.setSurfaceSize(const Size(1500, 900));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Only Fallback'), findsOneWidget);
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => AdvancedResponsiveLayoutBuilder(
          fallback: (context, screenInfo) => Text('Breakpoint Test ${screenInfo.size.name}'),
        ),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly with complex layouts', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          AdvancedResponsiveLayoutBuilder(
            fallback: (context, screenInfo) => Column(
              children: List.generate(
                20,
                (index) => Container(
                  height: 50,
                  child: Text('Performance Item $index'),
                ),
              ),
            ),
          ),
          maxRenderTimeMs: 200,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very small screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(100, 100));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) => const Text('Very Small'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Very Small'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very large screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(5000, 3000));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) => const Text('Very Large'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Very Large'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle extreme aspect ratios', (tester) async {
        // Very wide screen
        await tester.binding.setSurfaceSize(const Size(3000, 200));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) => Text('Extreme Wide: ${screenInfo.aspectRatio.toStringAsFixed(1)}'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Extreme Wide'), findsOneWidget);

        // Very tall screen
        await tester.binding.setSurfaceSize(const Size(200, 3000));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdvancedResponsiveLayoutBuilder(
              fallback: (context, screenInfo) => Text('Extreme Tall: ${screenInfo.aspectRatio.toStringAsFixed(1)}'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Extreme Tall'), findsOneWidget);
      });
    });
  });

  group('ScreenInfo Tests', () {
    testWidgets('should provide accurate screen information', (tester) async {
      ScreenInfo? capturedScreenInfo;

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          AdvancedResponsiveLayoutBuilder(
            fallback: (context, screenInfo) {
              capturedScreenInfo = screenInfo;
              return const Text('Test');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedScreenInfo, isNotNull);
      expect(capturedScreenInfo!.width, equals(800.0));
      expect(capturedScreenInfo!.height, equals(600.0));
      expect(capturedScreenInfo!.aspectRatio, closeTo(800.0 / 600.0, 0.01));
    });

    group('Recommended Values', () {
      testWidgets('should provide correct recommended columns', (tester) async {
        final testCases = [
          (const Size(250, 400), AdvancedScreenSize.tiny, 1),
          (const Size(500, 600), AdvancedScreenSize.small, 1),
          (const Size(500, 300), AdvancedScreenSize.small, 2), // landscape
          (const Size(800, 600), AdvancedScreenSize.medium, 2),
          (const Size(1100, 800), AdvancedScreenSize.large, 2),
          (const Size(1500, 900), AdvancedScreenSize.extraLarge, 3),
          (const Size(2000, 1080), AdvancedScreenSize.desktop, 4),
        ];

        for (final (size, expectedScreenSize, expectedColumns) in testCases) {
          ScreenInfo? screenInfo;

          await tester.binding.setSurfaceSize(size);
          await tester.pumpWidget(
            TestHelpers.createTestApp(
              AdvancedResponsiveLayoutBuilder(
                fallback: (context, info) {
                  screenInfo = info;
                  return const Text('Test');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(screenInfo!.size, equals(expectedScreenSize));
          expect(screenInfo!.recommendedColumns, equals(expectedColumns),
              reason: 'Expected $expectedColumns columns for ${size.width}x${size.height}');
        }
      });

      testWidgets('should provide correct recommended padding', (tester) async {
        final testCases = [
          (AdvancedScreenSize.tiny, 8.0),
          (AdvancedScreenSize.small, 16.0),
          (AdvancedScreenSize.medium, 20.0),
          (AdvancedScreenSize.large, 24.0),
          (AdvancedScreenSize.extraLarge, 28.0),
          (AdvancedScreenSize.desktop, 32.0),
        ];

        for (final (screenSize, expectedPadding) in testCases) {
          final screenInfo = ScreenInfo(
            size: screenSize,
            orientation: DeviceOrientation.portrait,
            deviceType: DeviceType.phone,
            width: 400,
            height: 800,
            aspectRatio: 0.5,
            isTabletInLandscape: false,
            isFoldableUnfolded: false,
            isDesktop: false,
          );

          expect(screenInfo.recommendedPadding, equals(expectedPadding));
        }
      });

      testWidgets('should provide correct max content width', (tester) async {
        final testCases = [
          (AdvancedScreenSize.tiny, double.infinity),
          (AdvancedScreenSize.small, double.infinity),
          (AdvancedScreenSize.medium, 800.0),
          (AdvancedScreenSize.large, 1000.0),
          (AdvancedScreenSize.extraLarge, 1200.0),
          (AdvancedScreenSize.desktop, 1400.0),
        ];

        for (final (screenSize, expectedWidth) in testCases) {
          final screenInfo = ScreenInfo(
            size: screenSize,
            orientation: DeviceOrientation.portrait,
            deviceType: DeviceType.phone,
            width: 400,
            height: 800,
            aspectRatio: 0.5,
            isTabletInLandscape: false,
            isFoldableUnfolded: false,
            isDesktop: false,
          );

          expect(screenInfo.maxContentWidth, equals(expectedWidth));
        }
      });
    });
  });

  group('AdvancedResponsiveMixin Tests', () {
    testWidgets('should provide screen info through mixin', (tester) async {
      late ScreenInfo screenInfo;

      final testWidget = _TestWidgetWithMixin(
        onScreenInfo: (info) => screenInfo = info,
      );

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          AdvancedResponsiveLayoutBuilder(
            fallback: (context, info) => testWidget,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(screenInfo.width, equals(800.0));
      expect(screenInfo.height, equals(600.0));
    });

    testWidgets('should provide fallback screen info when no builder ancestor', (tester) async {
      late ScreenInfo screenInfo;

      final testWidget = _TestWidgetWithMixin(
        onScreenInfo: (info) => screenInfo = info,
      );

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(testWidget));
      await tester.pumpAndSettle();

      expect(screenInfo.width, equals(800.0));
      expect(screenInfo.height, equals(600.0));
    });
  });

  group('ResponsiveContext Extension Tests', () {
    testWidgets('should provide screen info through context extension', (tester) async {
      late ScreenInfo screenInfo;

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          AdvancedResponsiveLayoutBuilder(
            fallback: (context, info) {
              screenInfo = context.screenInfo;
              return const Text('Test');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(screenInfo.width, equals(800.0));
      expect(screenInfo.height, equals(600.0));
    });

    testWidgets('should provide correct convenience methods', (tester) async {
      bool? isSmall, isLarge, isTabletLandscape, isFoldableUnfolded;

      await tester.binding.setSurfaceSize(const Size(500, 600)); // Small screen
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          AdvancedResponsiveLayoutBuilder(
            fallback: (context, info) {
              isSmall = context.isSmallScreen;
              isLarge = context.isLargeScreen;
              isTabletLandscape = context.isTabletInLandscape;
              isFoldableUnfolded = context.isFoldableUnfolded;
              return const Text('Test');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(isSmall, isTrue);
      expect(isLarge, isFalse);
      expect(isTabletLandscape, isFalse);
      expect(isFoldableUnfolded, isFalse);
    });
  });
}

class _TestWidgetWithMixin extends StatelessWidget with AdvancedResponsiveMixin {
  final Function(ScreenInfo) onScreenInfo;

  const _TestWidgetWithMixin({required this.onScreenInfo});

  @override
  Widget build(BuildContext context) {
    final screenInfo = getScreenInfo(context);
    onScreenInfo(screenInfo);
    return Text('Test Widget: ${screenInfo.size.name}');
  }
}