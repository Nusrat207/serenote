import 'dart:async';
import 'package:flutter/material.dart';
import 'package:serenote/features/timer/presentation/widgets/timer_settings_sheet.dart';
import 'package:serenote/features/timer/presentation/widgets/timer_theme_sheet.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _pomodoroMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;
  int _customHours = 0;
  int _customMinutes = 0;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  String _selectedTheme = 'Study';
  TimerType _currentTimerType = TimerType.pomodoro;
  bool _isPomodoroMode = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _getInitialSeconds();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          // Timer completed - show notification or sound
          _showTimerCompleteDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _remainingSeconds = _getInitialSeconds();
    });
    _timer?.cancel();
  }

  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Timer Complete!'),
          content: Text('Your $_selectedTheme session is complete.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  int _getInitialSeconds() {
    if (_isPomodoroMode) {
      switch (_currentTimerType) {
        case TimerType.pomodoro:
          return _pomodoroMinutes * 60;
        case TimerType.shortBreak:
          return _shortBreakMinutes * 60;
        case TimerType.longBreak:
          return _longBreakMinutes * 60;
        case TimerType.custom:
          return (_customHours * 3600) + (_customMinutes * 60);
      }
    } else {
      return (_customHours * 3600) + (_customMinutes * 60);
    }
  }

  void _setTimerType(TimerType type) {
    setState(() {
      _currentTimerType = type;
      _remainingSeconds = _getInitialSeconds();
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _toggleMode(bool isPomodoro) {
    setState(() {
      _isPomodoroMode = isPomodoro;
      if (isPomodoro) {
        _currentTimerType = TimerType.pomodoro;
      }
      _remainingSeconds = _getInitialSeconds();
      _isRunning = false;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Mode Selector - Pomodoro / Normal Timer
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleMode(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isPomodoroMode ? Colors.purpleAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Pomodoro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isPomodoroMode ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleMode(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isPomodoroMode ? Colors.purpleAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Normal Timer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isPomodoroMode ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pomodoro Type Selector (only show in Pomodoro mode)
          if (_isPomodoroMode) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPomodoroTypeButton('Focus', TimerType.pomodoro),
                  _buildPomodoroTypeButton('Short Break', TimerType.shortBreak),
                  _buildPomodoroTypeButton('Long Break', TimerType.longBreak),
                ],
              ),
            ),
          ],

          // Custom Time Input (only show in Normal Timer mode)
          if (!_isPomodoroMode) ...[
            const SizedBox(height: 20),
            _buildCustomTimeInput(),
          ],

          const SizedBox(height: 40),

          // Timer Display
          _buildTimerDisplay(),

          const SizedBox(height: 40),

          // Control Buttons
          _buildControlButtons(),

          const Spacer(),

          // Bottom Options - Only Settings and Themes
          _buildBottomOptions(),
        ],
      ),
    );
  }

  Widget _buildPomodoroTypeButton(String label, TimerType type) {
    final bool isSelected = _currentTimerType == type;
    return GestureDetector(
      onTap: () => _setTimerType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purpleAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.purpleAccent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTimeInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Set Timer Duration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Hours'),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: _customHours,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(3, (index) => index)
                          .map((hour) => DropdownMenuItem(
                                value: hour,
                                child: Text('$hour'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _customHours = value!;
                          _remainingSeconds = _getInitialSeconds();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Minutes'),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: _customMinutes,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(60, (index) => index)
                          .map((minute) => DropdownMenuItem(
                                value: minute,
                                child: Text('$minute'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _customMinutes = value!;
                          _remainingSeconds = _getInitialSeconds();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.purpleAccent.withOpacity(0.3),
              width: 8,
            ),
          ),
        ),
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purpleAccent.withOpacity(0.1),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedTheme,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: _isRunning ? _pauseTimer : _startTimer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purpleAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          _isRunning 
              ? 'Pause' 
              : _isPomodoroMode 
                  ? 'Start'
                  : 'Start Timer',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (_currentTimerType) {
      case TimerType.pomodoro:
        return 'Focus';
      case TimerType.shortBreak:
        return 'Short Break';
      case TimerType.longBreak:
        return 'Long Break';
      case TimerType.custom:
        return 'Timer';
    }
  }

  Widget _buildBottomOptions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomOption(Icons.settings_outlined, 'Settings', () {
            _showSettingsSheet();
          }),
          _buildBottomOption(Icons.palette_outlined, 'Themes', () {
            _showThemeSheet();
          }),
        ],
      ),
    );
  }

  Widget _buildBottomOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: Colors.purpleAccent,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimerSettingsSheet(
        pomodoroCycle: _pomodoroMinutes,
        shortBreak: _shortBreakMinutes,
        longBreak: _longBreakMinutes,
        onSettingsChanged: (pomodoro, shortBreak, longBreak) {
          setState(() {
            _pomodoroMinutes = pomodoro;
            _shortBreakMinutes = shortBreak;
            _longBreakMinutes = longBreak;
            _remainingSeconds = _getInitialSeconds();
          });
        },
      ),
    );
  }

  void _showThemeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimerThemeSheet(
        currentTheme: _selectedTheme,
        onThemeChanged: (theme) {
          setState(() {
            _selectedTheme = theme;
          });
        },
      ),
    );
  }
}

enum TimerType {
  pomodoro,
  shortBreak,
  longBreak,
  custom,
}