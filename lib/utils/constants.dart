// Additional constants that don't fit in other constant files
class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.recipebook.com';
  static const int requestTimeout = 30000; // 30 seconds
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String favoritesKey = 'favorite_recipes';
  static const String settingsKey = 'app_settings';
  
  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxRecipeTitleLength = 100;
  static const int maxRecipeDescriptionLength = 500;
  static const int maxIngredientsCount = 50;
  static const int maxInstructionsCount = 20;
  
  // Image Constants
  static const String defaultRecipeImage = 'assets/images/default_recipe.jpg';
  static const String defaultUserAvatar = 'assets/images/default_avatar.png';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Pagination
  static const int recipesPerPage = 10;
  static const int categoriesPerPage = 20;
}