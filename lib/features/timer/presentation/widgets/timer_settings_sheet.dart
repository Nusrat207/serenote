import 'package:flutter/material.dart';
import 'package:serenote/l10n/app_localizations.dart';

class TimerSettingsSheet extends StatefulWidget {
  final int pomodoroCycle;
  final int shortBreak;
  final int longBreak;
  final Function(int, int, int) onSettingsChanged;

  const TimerSettingsSheet({
    super.key,
    required this.pomodoroCycle,
    required this.shortBreak,
    required this.longBreak,
    required this.onSettingsChanged,
  });

  @override
  State<TimerSettingsSheet> createState() => _TimerSettingsSheetState();
}

class _TimerSettingsSheetState extends State<TimerSettingsSheet> {
  late int _pomodoroCycle;
  late int _shortBreak;
  late int _longBreak;

  @override
  void initState() {
    super.initState();
    _pomodoroCycle = widget.pomodoroCycle;
    _shortBreak = widget.shortBreak;
    _longBreak = widget.longBreak;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final double maxSheetHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/images/timeer.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.settingsTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Scrollable body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.pomodoroTechnique,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Focus Duration
                      _buildNumberSetting(
                        loc.focusDuration,
                        loc.minutes,
                        _pomodoroCycle,
                        1,
                        60,
                        (value) => setState(() => _pomodoroCycle = value),
                      ),

                      const SizedBox(height: 16),

                      // Short Break
                      _buildNumberSetting(
                        loc.shortBreak,
                        loc.minutes,
                        _shortBreak,
                        1,
                        30,
                        (value) => setState(() => _shortBreak = value),
                      ),

                      const SizedBox(height: 16),

                      // Long Break
                      _buildNumberSetting(
                        loc.longBreak,
                        loc.minutes,
                        _longBreak,
                        1,
                        60,
                        (value) => setState(() => _longBreak = value),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Footer (Save button)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSettingsChanged(
                          _pomodoroCycle, _shortBreak, _longBreak);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 71, 134, 145),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(loc.saveSettings),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSetting(
    String title,
    String unit,
    int value,
    int min,
    int max,
    Function(int) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$value $unit',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: const Color.fromARGB(255, 71, 134, 145),
                  onPressed: () {
                    if (value > min) onChanged(value - 1);
                  },
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.purple,
                  onPressed: () {
                    if (value < max) onChanged(value + 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
