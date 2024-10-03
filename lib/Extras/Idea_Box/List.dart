import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_code/main.dart';

Widget searchListView(List responses, bool isResponseForDestination,
    TextEditingController starter) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: responses.length,
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          ListTile(
            onTap: () {
              String text = responses[index]['place'];
              starter.text = text;
              sharedPreferences.setString(
                  'source', json.encode(responses[index]));
            },
            leading: const SizedBox(
              height: double.infinity,
              child: CircleAvatar(
                child: Icon(Icons.map),
                backgroundColor: Color(0xFF00bf7d),
              ),
            ),
            title: Text(responses[index]['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(responses[index]['address'],
                overflow: TextOverflow.ellipsis),
          ),
          const Divider(),
        ],
      );
    },
  );
}
