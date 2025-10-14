import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Games',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search games...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () {
                      // Filter functionality
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Games List Header
            const Text(
              'All Games',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Games List
            Expanded(
              child: ListView(
                children: [
                  _buildGameItem('Cali of Duty', Icons.sports_esports, Colors.blue),
                  _buildGameItem('Public Mobile', Icons.phone_android, Colors.green),
                  _buildGameItem('Magic Awakened', Icons.auto_awesome, Colors.purple),
                  _buildGameItem('Megic Awakened Stardew Valley', Icons.landscape, Colors.green),
                  _buildGameItem('My Dear Farm', Icons.agriculture, Colors.lightGreen),
                  _buildGameItem('Adorable Home', Icons.house, Colors.orange),
                  _buildGameItem('Campliro Cafe', Icons.coffee, Colors.brown),
                  _buildGameItem('Tudi Odyssey', Icons.travel_explore, Colors.teal),
                  _buildGameItem('Cats & Soup', Icons.soup_kitchen, Colors.amber),
                  _buildGameItem('Harvest Town Cookies Must Do', Icons.cookie, Colors.orange),
                  _buildGameItem('Window Garden', Icons.spa, Colors.lightGreen),
                  _buildGameItem('Oilies Dance', Icons.music_note, Colors.pink),
                  _buildGameItem('Anemos', Icons.air, Colors.cyan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameItem(String gameName, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Game Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Game Name
          Expanded(
            child: Text(
              gameName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Play Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Play',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}