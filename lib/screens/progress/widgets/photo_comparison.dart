import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PhotoComparison extends StatelessWidget {
  const PhotoComparison({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - would load from provider in real app
    final photos = [
      {'date': 'Week 1', 'icon': '📸'},
      {'date': 'Week 2', 'icon': '📸'},
      {'date': 'Week 3', 'icon': '📸'},
      {'date': 'Week 4', 'icon': '📸'},
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Card(
              color: AppTheme.secondaryDark,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          photo['icon']!,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      photo['date']!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}