import 'package:flutter/widgets.dart';

class SettingsModel {
  final String id;
  final String name;
  final IconData icon;
  final String description;

  const SettingsModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
    );
  }
}
