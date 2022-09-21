import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key, required this.permissions}) : super(key: key);
  final List<String> permissions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(children: permissions.map((e) => Text(e)).toList()),
    );
  }
}
