import '../enums/gametheme.dart';
import '../global/global.dart';
import '../utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

typedef GameThemeCallback = Function(GameTheme gameTheme);

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    Key? key,
    required this.selected,
    required this.gameTheme,
    required this.gameThemeCallback,
  }) : super(key: key);

  final bool selected;
  final GameTheme gameTheme;
  final GameThemeCallback gameThemeCallback;

  @override
  Widget build(BuildContext context) {
    final colors = Global.colors; // Local reference, safer and cleaner

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            gameThemeCallback(gameTheme);
            HapticFeedback.mediumImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            height: 167,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: selected
                  ? (colors?.darkIconColor ?? Colors.deepPurple)
                  : (colors?.lightIconColor ?? Colors.white),
              boxShadow: selected
                  ? [
                      // bright outer glow
                      BoxShadow(
                        color: Colors.white.withOpacity(0.7),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                      // tinted depth shadow
                      BoxShadow(
                        color: (colors?.darkIconColor ?? Colors.deepPurple)
                            .withOpacity(0.6),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Center(
              child: Container(
                width: 95,
                height: 155,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  gradient: Global.gameThemeGradients.gradients[gameTheme],
                ),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: SvgPicture.asset(
                      'assets/images/${gameTheme.name}.svg',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: selected,
          child: Text(
            gameTheme.name.capitalize(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
