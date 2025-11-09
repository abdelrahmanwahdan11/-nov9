import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/preferences/prefs_service.dart';
import '../../../core/router/app_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.routerState, required this.prefs});

  final AppRouterState routerState;
  final PrefsService prefs;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _controller;
  late Timer _timer;
  int _index = 0;

  final _slides = const [
    _OnboardingSlide(
      title: 'Curated daily events',
      subtitle: 'Politics, arts, and world happenings carefully sorted for you.',
      image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
    ),
    _OnboardingSlide(
      title: 'Collectibles catalog',
      subtitle: 'Track your items, compare specs, and receive offers.',
      image: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
    ),
    _OnboardingSlide(
      title: 'Bilingual insights',
      subtitle: 'Switch between Arabic and English at any moment.',
      image: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_index < _slides.length - 1) {
        _index++;
        _controller.animateToPage(_index, duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (value) {
                setState(() => _index = value);
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) => _OnboardingSlideView(slide: _slides[index]),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: () async {
                  await _completeOnboarding();
                },
                child: Text(l10n.translate('skip')),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: Row(
                children: [
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: index == _index ? 32 : 12,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == _index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      if (_index == _slides.length - 1) {
                        await _completeOnboarding();
                      } else {
                        _index++;
                        _controller.animateToPage(
                          _index,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Text(_index == _slides.length - 1 ? l10n.translate('get_started') : l10n.translate('next')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    await widget.prefs.setCompletedOnboarding();
    widget.routerState.replace(AppPage.auth);
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({required this.title, required this.subtitle, required this.image});
  final String title;
  final String subtitle;
  final String image;
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rawHeight = constraints.maxHeight.isFinite ? constraints.maxHeight * 0.55 : 360.0;
        final imageHeight = rawHeight.clamp(240.0, 420.0).toDouble();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Image.network(slide.image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  slide.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                Text(
                  slide.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 56),
              ],
            ),
          ),
        );
      },
    );
  }
}
