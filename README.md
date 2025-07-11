# Recipe Book Login - Flutter App

A beautiful Flutter login screen for a Recipe Book application, recreated from the original React design.

## Features

- Clean, modern login interface
- Custom text fields with underline styling
- Responsive design that works on various screen sizes
- Pre-filled demo credentials
- Smooth animations and interactions
- Google Fonts (Poppins) integration
- Material Design components

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   └── login_screen.dart     # Main login screen
├── widgets/
│   ├── custom_text_field.dart # Custom input field component
│   └── login_button.dart     # Custom login button component
├── models/
│   └── user.dart            # User data model
└── services/
    └── auth_service.dart    # Authentication service
```

## Design Features

- **Typography**: Uses Poppins font family for a modern look
- **Colors**: Soft orange/peach theme with clean white background
- **Layout**: Centered design optimized for mobile screens
- **Interactions**: Smooth button hover effects and input focus states

## Demo Credentials

- Username: `emlys`
- Password: `password123`

## Customization

You can easily customize the app by:

- Modifying colors in the theme
- Changing fonts in `main.dart`
- Adding new authentication methods in `auth_service.dart`
- Extending the UI with additional screens

## Building for Production

To build the app for release:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.