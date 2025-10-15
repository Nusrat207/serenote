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
  // Initialize with Pomodoro duration, as the type selector is removed
  int _remainingSeconds = 25 * 60; 
  bool _isRunning = false;
  String _selectedTheme = 'Study';
  // Removed TimerType _currentTimerType = TimerType.pomodoro;
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
          // Simplified text since we don't track TimerType locally anymore
          content: Text('Your session is complete.'), 
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Auto-reset timer after completion dialog
                _resetTimer(); 
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
      // In Pomodoro mode, we now always use the Pomodoro minutes
      return _pomodoroMinutes * 60;
    } else {
      // In Normal Timer mode, use custom hours and minutes
      return (_customHours * 3600) + (_customMinutes * 60);
    }
  }

  // Removed _setTimerType function as type selection is gone

  void _toggleMode(bool isPomodoro) {
    setState(() {
      _isPomodoroMode = isPomodoro;
      
      // Removed _currentTimerType logic
      
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
      // --- WRAP COLUMN IN SINGLECHILDSCROLLVIEW ---
      body: Stack( // Added Stack for background image
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/timeer.png', // <--- REPLACE WITH YOUR IMAGE PATH
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Mode Selector - Pomodoro / Normal Timer
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.8), // Adjusted for visibility
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
                              color: _isPomodoroMode ? const Color.fromARGB(255, 71, 134, 145): Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Pomodoro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isPomodoroMode ? Colors.white : Colors.grey.shade800, // Adjusted text color
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
                              color: !_isPomodoroMode ? const Color.fromARGB(255, 71, 134, 145) : const Color.fromARGB(0, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Normal Timer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !_isPomodoroMode ? Colors.white : Colors.grey.shade800, // Adjusted text color
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Pomodoro Type Selector (Removed this block)
                if (_isPomodoroMode) ...[
                  const SizedBox(height: 20),
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

                // Add some vertical space instead of the Spacer
                const SizedBox(height: 20),

                // Bottom Options - Only Settings and Themes
                _buildBottomOptions(),
              ],
            ),
          ),
        ],
      ),
      // ----------------------------------------------
    );
  }
  
  // Removed _buildPomodoroTypeButton as it's no longer used

  Widget _buildCustomTimeInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      // Adjusted background color for visibility over image
      decoration: BoxDecoration( 
        color: Colors.white.withOpacity(0.8), 
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20), // Added margin for spacing
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
                      color: Colors.white, // Ensure dropdown background is white
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
                      color: Colors.white, // Ensure dropdown background is white
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
        // Reduced size from 280 to 220
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 71, 134, 145).withOpacity(0.3),
              width: 8,
            ),
            color: Colors.white.withOpacity(0.2), // Added slight background to timer circles
          ),
        ),
        // Reduced size from 260 to 200
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 71, 134, 145).withOpacity(0.1),
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
        onPressed: (_isPomodoroMode && _remainingSeconds == 0) || (!_isPomodoroMode && (_customHours == 0 && _customMinutes == 0 && _remainingSeconds == 0)) 
            ? null // Disable button if time is 0 and we are not running
            : _isRunning ? _pauseTimer : _startTimer,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 71, 134, 145),
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

  // Removed _getButtonText function as it was related to TimerType

  Widget _buildBottomOptions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container( // Added Container for background
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Adjusted for visibility
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomOption(Icons.refresh_outlined, 'Reset', () {
              _resetTimer();
            }),
            _buildBottomOption(Icons.settings_outlined, 'Settings', () {
              _showSettingsSheet();
            }),
            _buildBottomOption(Icons.palette_outlined, 'Themes', () {
              _showThemeSheet();
            }),
          ],
        ),
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
            color:  const Color.fromARGB(255, 71, 134, 145),
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
    // Handling case where seconds might briefly be negative (though unlikely with current logic)
    if (seconds < 0) seconds = 0; 
    
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    // Only show hours in Normal Timer Mode (or if the time is > 1 hour in Pomodoro, though it shouldn't be)
    if (hours > 0 || !_isPomodoroMode) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      // Pomodoro mode/times under 1 hour only show MM:SS
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  void _showSettingsSheet() {
    // Temporarily pause the timer while settings are being adjusted
    if (_isRunning) _pauseTimer(); 

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
    if (_isRunning) _pauseTimer();

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

// Keeping the enum for external widget compatibility, but TimerScreen doesn't use it internally now
enum TimerType {
  pomodoro,
  shortBreak,
  longBreak,
  custom,
}