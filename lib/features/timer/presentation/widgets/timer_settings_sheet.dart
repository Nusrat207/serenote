import 'package:flutter/material.dart';

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
    // 1. Determine Max Height (e.g., up to 90% of screen height)
    final double maxSheetHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      // 2. Set Max Height Constraint
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        // Color removed as background image will cover it
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack( // 3. Use Stack for background image
        children: [
          // Background Image Layer
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/images/timeer.png', // <--- REPLACE WITH YOUR IMAGE PATH
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Content Layer (Scrollable Body and Fixed Footer)
          Column(
            mainAxisSize: MainAxisSize.min, // Allows Column to shrink to content height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4. Fixed Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Ensure visibility over background
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 5. Scrollable Body
              Flexible( // Allows SingleChildScrollView to take remaining space
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pomodoro Technique',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87, // Ensure visibility
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Pomodoro Cycle Setting
                      _buildNumberSetting(
                        'Focus Duration',
                        'minutes',
                        _pomodoroCycle,
                        1,
                        60,
                        (value) {
                          setState(() {
                            _pomodoroCycle = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Short Break Setting
                      _buildNumberSetting(
                        'Short Break',
                        'minutes',
                        _shortBreak,
                        1,
                        30,
                        (value) {
                          setState(() {
                            _shortBreak = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Long Break Setting
                      _buildNumberSetting(
                        'Long Break',
                        'minutes',
                        _longBreak,
                        1,
                        60,
                        (value) {
                          setState(() {
                            _longBreak = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      // Add padding below the last setting before the button area
                    ],
                  ),
                ),
              ),
              
              // 6. Fixed Footer Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSettingsChanged(_pomodoroCycle, _shortBreak, _longBreak);
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
                    child: const Text('Save Settings'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSetting(String title, String unit, int value, int min, int max, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      // Add a slight background for better contrast against the image
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
                    if (value > min) {
                      onChanged(value - 1);
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white, // Solid white background for value
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
                    if (value < max) {
                      onChanged(value + 1);
                    }
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