import '../enums/mapsize.dart';
import '../global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef MapCallback = Function(MapSize mapSize);

class MapCard extends StatelessWidget {
  const MapCard({
    Key? key,
    required this.selected,
    required this.mapCallback,
    required this.mapSize,
  }) : super(key: key);

  final bool selected;
  final MapSize mapSize;
  final MapCallback mapCallback;

  String get _title {
    switch (mapSize) {
      case MapSize.fourxfour:
        return '4x4';
      case MapSize.fivexsix:
        return '5x6';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mapCallback(mapSize);
        HapticFeedback.mediumImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 90,
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? Global.colors.darkIconColor.withOpacity(0.95)
              : Global.colors.lightIconColor,
          gradient: selected
              ? LinearGradient(
                  colors: [
                    Global.colors.darkIconColor.withOpacity(0.9),
                    Global.colors.darkIconColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Global.colors.darkIconColor.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Global.colors.darkIconColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: selected
                ? Colors.white.withOpacity(0.6)
                : Colors.transparent,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: AnimatedScale(
          scale: selected ? 1.07 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Stack(
            children: [
              // Map image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/map_$_title.png',
                    fit: BoxFit.cover,
                    color: selected
                        ? Colors.white.withOpacity(0.05)
                        : null,
                    colorBlendMode:
                        selected ? BlendMode.lighten : BlendMode.dst,
                  ),
                ),
              ),

              // Size label overlay (bottom)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.black.withOpacity(0.55)
                        : Colors.black.withOpacity(0.35),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(14),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: Text(
                    _title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
