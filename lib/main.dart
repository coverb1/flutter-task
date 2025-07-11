import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'core/routes/app_routes.dart';
import 'core/constants/app_strings.dart';

void main() {
  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const AuthScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.recipeDetail:
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipe: args?['recipe'],
                recipeId: args?['recipeId'],
              ),
            );
          case '/add-recipe':
            return MaterialPageRoute(
              builder: (context) => const AddRecipeScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            );
        }
      },
    );
  }
}