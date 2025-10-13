import 'package:flutter/material.dart';

class TimerThemeSheet extends StatefulWidget {
  final String currentTheme;
  final Function(String) onThemeChanged;

  const TimerThemeSheet({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<TimerThemeSheet> createState() => _TimerThemeSheetState();
}

class _TimerThemeSheetState extends State<TimerThemeSheet> {
  late String _selectedTheme;
  final TextEditingController _customThemeController = TextEditingController();
  final List<String> _defaultThemes = ['Focus', 'Read', 'Study', 'Workout', 'Work', 'Meditate', 'Relax'];
  final List<String> _customThemes = [];

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                'Custom Themes',
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
          
          const SizedBox(height: 8),
          
          Text(
            '${_customThemes.length}/50',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Default Themes Grid
          const Text(
            'Default Themes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _defaultThemes.map((theme) {
              return _buildThemeChip(theme);
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Custom Themes
          if (_customThemes.isNotEmpty) ...[
            const Text(
              'Custom Themes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _customThemes.map((theme) {
                return _buildThemeChip(theme);
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          
          // Custom Theme Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Custom Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _customThemeController,
                  decoration: InputDecoration(
                    hintText: 'Enter theme name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCustomTheme,
                    ),
                  ),
                  onSubmitted: (value) => _addCustomTheme(),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onThemeChanged(_selectedTheme);
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
              child: const Text('Apply Theme'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeChip(String theme) {
    final bool isSelected = _selectedTheme == theme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purpleAccent : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.purpleAccent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          theme,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _addCustomTheme() {
    final themeName = _customThemeController.text.trim();
    if (themeName.isNotEmpty && _customThemes.length < 50 && !_defaultThemes.contains(themeName) && !_customThemes.contains(themeName)) {
      setState(() {
        _customThemes.add(themeName);
        _selectedTheme = themeName;
        _customThemeController.clear();
      });
    }
  }
}