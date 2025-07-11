import '../models/recipe.dart';
import '../models/category.dart';
import '../data/mock_data.dart';

class RecipeService {
  static final RecipeService _instance = RecipeService._internal();
  factory RecipeService() => _instance;
  RecipeService._internal();

  List<Recipe> _recipes = MockData.recipes;
  List<Recipe> _favoriteRecipes = [];

  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _recipes;
  }

  // Get featured recipes
  Future<List<Recipe>> getFeaturedRecipes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _recipes.where((recipe) => recipe.rating >= 4.5).toList();
  }

  // Get recipes by category
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _recipes.where((recipe) => recipe.category == category).toList();
  }

  // Search recipes
  Future<List<Recipe>> searchRecipes(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (query.isEmpty) return _recipes;
    
    return _recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
             recipe.description.toLowerCase().contains(query.toLowerCase()) ||
             recipe.ingredients.any((ingredient) => 
               ingredient.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Get recipe by ID
  Future<Recipe?> getRecipeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get categories
  Future<List<RecipeCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.categories;
  }

  // Favorite operations
  Future<List<Recipe>> getFavoriteRecipes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _favoriteRecipes;
  }

  Future<bool> toggleFavorite(String recipeId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final recipe = _recipes.firstWhere((r) => r.id == recipeId);
    final isFavorite = _favoriteRecipes.any((r) => r.id == recipeId);
    
    if (isFavorite) {
      _favoriteRecipes.removeWhere((r) => r.id == recipeId);
      // Update recipe in main list
      final index = _recipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        _recipes[index] = recipe.copyWith(isFavorite: false);
      }
      return false;
    } else {
      final updatedRecipe = recipe.copyWith(isFavorite: true);
      _favoriteRecipes.add(updatedRecipe);
      // Update recipe in main list
      final index = _recipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
      }
      return true;
    }
  }

  bool isRecipeFavorite(String recipeId) {
    return _favoriteRecipes.any((recipe) => recipe.id == recipeId);
  }
}