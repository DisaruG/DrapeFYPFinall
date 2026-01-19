import 'package:flutter/material.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of dummy data to show in the grid.
    // In the real app, this would come from your database.
    final List<Map<String, String>> clothes = [
      {
        'name': 'Casual T-Shirt',
        'image': 'https://placehold.co/400x400/png?text=T-Shirt',
      },
      {
        'name': 'Denim Jacket',
        'image': 'https://placehold.co/400x400/png?text=Jacket',
      },
      {
        'name': 'Black Jeans',
        'image': 'https://placehold.co/400x400/png?text=Jeans',
      },
      {
        'name': 'Summer Dress',
        'image': 'https://placehold.co/400x400/png?text=Dress',
      },
      {
        'name': 'Hoodie',
        'image': 'https://placehold.co/400x400/png?text=Hoodie',
      },
      {
        'name': 'Sneakers',
        'image': 'https://placehold.co/400x400/png?text=Sneakers',
      },
    ];

    return Scaffold(
      // The floating button adds the "Upload" feature (FR-03)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Later, we will open the camera here
          print("Upload button clicked");
        },
        child: const Icon(Icons.add_a_photo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: clothes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8, // Taller cards
          ),
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    // Display the image from the web
                    child: Image.network(
                      clothes[index]['image']!,
                      fit: BoxFit.cover,
                      // Loading builder handles the "spinner" while image loads
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      clothes[index]['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}