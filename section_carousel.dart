import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SectionCarousel extends StatefulWidget {
  final List<List<Widget>> lections;
  final int unlockedLevel;

  const SectionCarousel({
    super.key,
    required this.lections,
    required this.unlockedLevel,
  });

  @override
  State<SectionCarousel> createState() => _SectionCarouselState();
}

class _SectionCarouselState extends State<SectionCarousel> {
  late int currentSectionIndex;
  late PageController pageController;
  List<String> topics = [
    'Antika',
    'Biblické a náboženské texty & raný středověk',
    'Pozdní středověk',
    'Středověká satira a drama',
    'Renesance a humanismus',
    'Pozdní humanismus & raný novověk',
    'Baroko',
    'Klasicismus a osvícenství',
    'Preromantismus a romantismus (zahraniční)',
    'Romantismus (český a ruský)',
    'Realismus (západoevropský)',
    'Realismus (východní Evropa a USA)',
    'Realismus (český)',
    'Ruchovci a lumírovci',
    'Májovci a obrozenci',
    'Česká moderna',
    'Generace buřičů',
    'Literární moderna (francouzská)',
    'Devětsil / Poetismus',
    'Skupina 42',
    'Modernismus a avantgarda',
    'Existencialismus',
    'Absurdní drama',
    'Magický realismus',
    'Socialistický realismus',
    'Lost Generation',
    'Beat generation',
    'Postmodernismus',
    'Další čeští autoři 20. století',
    'Dramatikové a básníci 20. století',
  ];

  @override
  void initState() {
    super.initState();
    currentSectionIndex = (widget.unlockedLevel ~/ 100) - 1;

    final initialLevel = widget.unlockedLevel % 100;
    final initialPage = initialLevel; // Odebrání "+1"

    // Vytvoř controller rovnou se správnou počáteční stránkou
    pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.6, // 60 % šířky obrazovky, zbytek pro boční itemy
    );
  }

  void showCongratulationPopup(BuildContext context, VoidCallback onContinue) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Gratulace",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🎉 Gratulujeme!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Dokončili jste tuto sekci.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onContinue();
                      },
                      child: Text('Pokračovat'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  void goToNextSection() {
    if (currentSectionIndex < widget.lections.length - 1) {
      showCongratulationPopup(context, () {
        setState(() {
          currentSectionIndex++;
          pageController = PageController(
            initialPage: currentSectionIndex == 0 ? 0 : 1,
            viewportFraction: 0.6,
          );
        });
      });
    }
  }

  List<Widget> getCurrentSectionWithControls() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFirstSection = currentSectionIndex == 0;
    final isLastSection = currentSectionIndex == widget.lections.length - 1;
    final section = widget.lections[currentSectionIndex];
    final int currentSectionStart = (currentSectionIndex + 1) * 100;
    final int lastLevelInSection = currentSectionStart + section.length - 1;
    final bool isUnlocked = widget.unlockedLevel > lastLevelInSection;

    final List<Widget> items = [];

    if (!isFirstSection) {
      items.add(
        Container(
          padding: EdgeInsets.all(20.0),
          height: 400.0,
          width: 250.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: colorScheme.secondary,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Vrátit se zpět',
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentSectionIndex--;
                      pageController = PageController(
                        initialPage: currentSectionIndex == 0 ? 0 : 1,
                        viewportFraction: 0.6,
                      );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 3,
                          blurRadius: 12, // 📌 Míra rozmazání stínu
                          offset: Offset(0, 4), // 📌 Posunutí dolů
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: colorScheme.onSurface,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    items.addAll(section);

    if (!isLastSection) {
      items.add(
        Container(
          padding: EdgeInsets.all(20.0),
          height: 400.0,
          width: 250.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: isUnlocked ? colorScheme.secondary : colorScheme.surface,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pokračovat',
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: isUnlocked ? goToNextSection : null,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 3,
                          blurRadius: 12, // 📌 Míra rozmazání stínu
                          offset: Offset(0, 4), // 📌 Posunutí dolů
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: colorScheme.onSurface,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final items = getCurrentSectionWithControls();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            topics[currentSectionIndex],
            style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w600),
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          child: SizedBox(
            key: ValueKey(currentSectionIndex), // Zde musí být
            height: 400,
            child: PageView.builder(
              controller: pageController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: pageController,
                  builder: (context, child) {
                    double scale = 1.0;
                    if (pageController.position.haveDimensions) {
                      final currentPage =
                          pageController.page ??
                          pageController.initialPage.toDouble();
                      scale = (1 - (currentPage - index).abs() * 0.3).clamp(
                        0.7,
                        1.0,
                      );
                    }
                    return Center(
                      child: Transform.scale(scale: scale, child: child),
                    );
                  },
                  child: items[index],
                );
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: SmoothPageIndicator(
              controller: pageController, // 📌 Spojení s PageView
              count: items.length, // 📌 Počet stránek
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: colorScheme.primary, // 📌 Aktivní tečka
                dotColor: colorScheme.surface, // 📌 Neaktivní tečky
              ),
            ),
          ),
        ),
      ],
    );
  }
}
