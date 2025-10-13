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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Pomodoro Technique',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSettingsChanged(_pomodoroCycle, _shortBreak, _longBreak);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSetting(String title, String unit, int value, int min, int max, Function(int) onChanged) {
    return Row(
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
              onPressed: () {
                if (value < max) {
                  onChanged(value + 1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}