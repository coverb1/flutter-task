import 'package:flutter/material.dart';

class RecipeCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int recipeCount;

  const RecipeCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.recipeCount,
  });

  factory RecipeCategory.fromJson(Map<String, dynamic> json) {
    return RecipeCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue'] as int),
      recipeCount: json['recipeCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
      'recipeCount': recipeCount,
    };
  }
}