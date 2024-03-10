//data_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data_model.dart';

class DataPage extends StatelessWidget {
  final List<ActivationEntry> activationEntries;

  DataPage({required this.activationEntries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activation History'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if(activationEntries.isEmpty)
              Text('No activations yet.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: activationEntries.length,
                  itemBuilder: (context, index) {
                    final entry = activationEntries[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Activated on ${entry.timestamp} '
                                'with ${entry.alertNum} alerts',
                            style: TextStyle(fontSize: 16),
                          ),
                          //add more widgets if i need
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}