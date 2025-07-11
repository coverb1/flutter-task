import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_form.dart';
import '../widgets/common/loading_widget.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _recipeService = RecipeService();
  bool _isLoading = false;

  Future<void> _handleSaveRecipe(Recipe recipe) async {
    setState(() => _isLoading = true);

    try {
      // In a real app, this would save to a backend
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save recipe: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        backgroundColor: AppColors.surface,
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Saving recipe...')
          : RecipeForm(
              onSave: _handleSaveRecipe,
            ),
    );
  }
}