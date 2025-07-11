import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../models/recipe.dart';
import '../models/category.dart';
import '../services/recipe_service.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/recipe_card.dart';
import '../screens/add_recipe_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/recipe_detail_screen.dart';
import 'package:recipe_book_login/core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _recipeService = RecipeService();
  int _currentIndex = 0;
  List<Recipe> _featuredRecipes = [];
  List<RecipeCategory> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final results = await Future.wait([
        _recipeService.getFeaturedRecipes(),
        _recipeService.getCategories(),
      ]);

      setState(() {
        _featuredRecipes = results[0] as List<Recipe>;
        _categories = results[1] as List<RecipeCategory>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildHomeTab() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading recipes...');
    }

    if (_error != null) {
      return CustomErrorWidget(
        message: _error!,
        onRetry: _loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    AppStrings.discoverRecipes,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingXL),

            // Categories Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.categories,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to categories screen
                  },
                  child: const Text(AppStrings.seeAll),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.paddingM),

            // Categories Grid
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: AppDimensions.paddingM),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          // Navigate to category recipes
                        },
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimensions.paddingM),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                category.icon,
                                size: AppDimensions.iconL,
                                color: category.color,
                              ),
                              const SizedBox(height: AppDimensions.paddingS),
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimensions.paddingXL),

            // Featured Recipes Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.featuredRecipes,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all recipes
                  },
                  child: const Text(AppStrings.seeAll),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.paddingM),

            // Featured Recipes List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _featuredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _featuredRecipes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.recipeDetail,
                        arguments: {'recipe': recipe},
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeTab(),
      const Center(child: Text('Search Screen')),
      const Center(child: Text('Favorites Screen')),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() => _currentIndex = 1);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipeScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: AppStrings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: AppStrings.favorites,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}