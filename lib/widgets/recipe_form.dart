import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../models/recipe.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? recipe;
  final Function(Recipe) onSave;

  const RecipeForm({
    super.key,
    this.recipe,
    required this.onSave,
  });

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  
  List<TextEditingController> _ingredientControllers = [];
  List<TextEditingController> _instructionControllers = [];
  
  String _selectedCategory = 'Main Course';
  String _selectedDifficulty = 'Medium';
  
  final List<String> _categories = [
    'Pizza',
    'Desserts',
    'Main Course',
    'Appetizers',
    'Beverages',
  ];
  
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.recipe != null) {
      final recipe = widget.recipe!;
      _titleController.text = recipe.title;
      _descriptionController.text = recipe.description;
      _imageUrlController.text = recipe.imageUrl;
      _cookingTimeController.text = recipe.cookingTimeMinutes.toString();
      _servingsController.text = recipe.servings.toString();
      _selectedCategory = recipe.category;
      _selectedDifficulty = recipe.difficulty;
      
      // Initialize ingredients
      _ingredientControllers = recipe.ingredients
          .map((ingredient) => TextEditingController(text: ingredient))
          .toList();
      
      // Initialize instructions
      _instructionControllers = recipe.instructions
          .map((instruction) => TextEditingController(text: instruction))
          .toList();
    } else {
      // Add initial empty fields
      _addIngredientField();
      _addInstructionField();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _cookingTimeController.dispose();
    _servingsController.dispose();
    
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }

  void _addInstructionField() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstructionField(int index) {
    if (_instructionControllers.length > 1) {
      setState(() {
        _instructionControllers[index].dispose();
        _instructionControllers.removeAt(index);
      });
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final instructions = _instructionControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one ingredient'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one instruction'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final recipe = Recipe(
      id: widget.recipe?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isEmpty 
          ? 'assets/images/default_recipe.jpg' 
          : _imageUrlController.text.trim(),
      ingredients: ingredients,
      instructions: instructions,
      cookingTimeMinutes: int.tryParse(_cookingTimeController.text) ?? 30,
      servings: int.tryParse(_servingsController.text) ?? 4,
      difficulty: _selectedDifficulty,
      category: _selectedCategory,
      rating: widget.recipe?.rating ?? 0.0,
      reviewCount: widget.recipe?.reviewCount ?? 0,
      isFavorite: widget.recipe?.isFavorite ?? false,
    );

    widget.onSave(recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Section
            _buildSectionTitle('Basic Information'),
            
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                hintText: 'Enter recipe title',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a recipe title';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the recipe',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                hintText: 'Enter image URL or leave empty for default',
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Category and Difficulty Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value!);
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                    ),
                    items: _difficulties.map((difficulty) {
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedDifficulty = value!);
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Cooking Time and Servings Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cookingTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Cooking Time (minutes)',
                      hintText: '30',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter cooking time';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    decoration: const InputDecoration(
                      labelText: 'Servings',
                      hintText: '4',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter servings';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Ingredients Section
            _buildSectionTitle('Ingredients'),
            
            ..._ingredientControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Ingredient ${index + 1}',
                          hintText: 'e.g., 2 cups flour',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeIngredientField(index),
                      color: AppColors.error,
                    ),
                  ],
                ),
              );
            }),
            
            TextButton.icon(
              onPressed: _addIngredientField,
              icon: const Icon(Icons.add),
              label: const Text('Add Ingredient'),
            ),
            
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Instructions Section
            _buildSectionTitle('Instructions'),
            
            ..._instructionControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Step ${index + 1}',
                          hintText: 'Describe this cooking step...',
                        ),
                        maxLines: 3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeInstructionField(index),
                      color: AppColors.error,
                    ),
                  ],
                ),
              );
            }),
            
            TextButton.icon(
              onPressed: _addInstructionField,
              icon: const Icon(Icons.add),
              label: const Text('Add Step'),
            ),
            
            const SizedBox(height: AppDimensions.paddingXXL),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightL,
              child: ElevatedButton(
                onPressed: _handleSave,
                child: Text(widget.recipe != null ? 'Update Recipe' : 'Save Recipe'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}