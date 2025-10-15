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
  final List<String> _customThemes = []; // Custom themes should ideally be loaded from state/storage

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }
  
  @override
  void dispose() {
    _customThemeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the height for the modal (up to 90% of screen height)
    final double maxSheetHeight = MediaQuery.of(context).size.height * 0.9;
    
    return Container(
      // Set height constraint for the Modal, allowing content to scroll within it
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      padding: const EdgeInsets.only(top: 20), // Padding for the header/top edge
      decoration: const BoxDecoration(
        // Remove the direct color here as the Stack will handle the background
        // color: Colors.white, 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack( // <--- Added Stack for background image
        children: [
          // Background Image (placed first to be at the bottom)
          Positioned.fill(
            child: ClipRRect( // Clip to respect the border radius of the parent Container
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
          // Existing content (Column) placed on top of the image
          Column( 
            mainAxisSize: MainAxisSize.min, 
            children: [
              // 1. Header Row (Fixed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Custom Themes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Ensure text is visible over background
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87), // Ensure icon is visible
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 2. Scrollable Body
              Flexible( 
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_customThemes.length}/50',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey, // Adjusted for visibility
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Default Themes Grid
                      const Text(
                        'Default Themes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87, // Ensure text is visible
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
                            color: Colors.black87, // Ensure text is visible
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
                          color: Colors.white.withOpacity(0.8), // Slightly opaque background for readability
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Create Custom Theme',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87, // Ensure text is visible
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
                                fillColor: Colors.white, // Ensure text field has a solid background
                                filled: true,
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
                      
                      const SizedBox(height: 20), 
                    ],
                  ),
                ),
              ),
              
              // 3. Apply Theme Button (Fixed)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), 
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onThemeChanged(_selectedTheme);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  const Color.fromARGB(255, 71, 134, 145),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply Theme'),
                  ),
                ),
              ),
            ],
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
          color: isSelected ? const Color.fromARGB(255, 71, 134, 145) : Colors.grey.shade100.withOpacity(0.7), // Adjusted opacity
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color.fromARGB(255, 71, 134, 145): Colors.grey.shade300.withOpacity(0.7), // Adjusted opacity
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