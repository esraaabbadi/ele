import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<List<String>> rows;

  CustomDataTable({
    required this.title,
    required this.headers,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Title
        // Padding(
        //   padding: const EdgeInsets.all(1.0),
        //   child: Text(
        //     title,
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),

        // Fixed Headers
        Container(
          color: Color.fromARGB(255, 6, 79, 92),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: headers.map((header) {
              return Expanded(
                child: Center(
                  child: Text(header,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          ),
        ),
        Divider(height: 1, color: Colors.black),

        // Scrollable Table Data
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: rows.map((row) {
                return Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    children: row.map((cellData) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            cellData,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
