# NaijaPaper Flutter - Quick Start Guide

## 🚀 Get Running in 5 Minutes

### Prerequisites
- Flutter SDK 3.24+ installed
- Android Studio / Xcode installed
- Firebase account (for push notifications)

### Step 1: Install Dependencies (1 min)

```bash
flutter pub get
```

### Step 2: Generate Drift Code (1 min)

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates `lib/local/drift/app_database.g.dart` from the Drift schema.

### Step 3: Run the App (1 min)

```bash
# Run on connected device/emulator
flutter run

# Or specify a device
flutter devices  # List available devices
flutter run -d <device-id>
```

### Step 4: Navigate the App (2 min)

The app will launch on the **Splash Screen** and automatically navigate to the **Welcome Screen** after 2 seconds.

**Current Flow:**
1. Splash → Welcome (onboarding carousel)
2. Welcome → Signup
3. Signup → OTP Verification (placeholder)
4. OTP → Profile Setup
5. Profile Setup → Subject Selection
6. Subject Selection → Notification Permission
7. Notification Permission → Dashboard

**Note:** Most screens are placeholders. The auth flow UI is complete but not connected to the backend yet.

## 🔧 Optional: Add Firebase (for push notifications)

### Android

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Add Android app with package name: `com.naijapaper.naijapaper`
4. Download `google-services.json`
5. Place in `android/app/google-services.json`

### iOS

1. In Firebase Console, add iOS app
2. Bundle ID: `com.naijapaper.naijapaper`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/GoogleService-Info.plist`

## 📱 Test on Physical Device

### Android

```bash
# Enable USB debugging on your Android device
# Connect via USB
flutter run
```

### iOS

```bash
# Connect iPhone via USB
# Trust computer on device
flutter run
```

## 🎨 Explore the Codebase

### Key Files to Start With

1. **`lib/main.dart`** - App entry point
2. **`lib/core/router/app_router.dart`** - All 42 routes
3. **`lib/core/theme/app_theme.dart`** - Colors and theme
4. **`lib/features/auth/presentation/`** - Auth screens (most complete)
5. **`lib/shared/widgets/`** - Reusable components

### Try Modifying

**Change the primary color:**
```dart
// lib/core/theme/app_theme.dart
static const Color primary = Color(0xFF1A7A4A); // Change this hex code
```

**Add a new route:**
```dart
// lib/core/router/app_router.dart
GoRoute(
  path: '/test',
  name: 'test',
  builder: (context, state) => TestScreen(),
),
```

**Create a new screen:**
```dart
// lib/features/test/test_screen.dart
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: Center(child: Text('Hello NaijaPaper!')),
    );
  }
}
```

## 🔍 Debugging

### View Logs

```bash
flutter logs
```

### Hot Reload

Press `r` in the terminal while app is running to hot reload changes.

### Hot Restart

Press `R` in the terminal to hot restart the app.

### Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Then open the URL shown in your browser.

## 📊 Check What's Working

### ✅ Working Now
- App launches successfully
- Navigation between screens
- Theme and colors display correctly
- Shared widgets render properly
- Form validation works
- OTP input auto-advances

### ⚠️ Not Working Yet (Expected)
- OAuth sign-in (buttons present, no logic)
- API calls (no backend connection)
- Data persistence (Drift needs implementation)
- Offline sync
- Push notifications

## 🐛 Common Issues

### Issue: Build fails with Drift error

**Solution:** Run build_runner first
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Firebase error on launch

**Solution:** Firebase config files are optional for now. The app will work without them. Add them when you need push notifications.

### Issue: "No devices found"

**Solution:** 
```bash
# Check connected devices
flutter devices

# For Android emulator
flutter emulators
flutter emulators --launch <emulator-id>

# For iOS simulator
open -a Simulator
```

### Issue: Gradle build fails (Android)

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: Pod install fails (iOS)

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

## 📚 Next Steps

Once you have the app running:

1. **Read the docs:**
   - `README_FLUTTER_STRUCTURE.md` - Understand the architecture
   - `IMPLEMENTATION_GUIDE.md` - Learn how to implement features
   - `PROJECT_STATUS.md` - See what's done and what's next

2. **Implement a feature:**
   - Start with completing the auth flow (see IMPLEMENTATION_GUIDE.md Phase 2)
   - Or build out the dashboard (see IMPLEMENTATION_GUIDE.md Phase 3)

3. **Connect to backend:**
   - Update `ApiConstants.baseUrl` in `lib/core/constants/api_constants.dart`
   - Implement Riverpod providers
   - Test API integration

4. **Add tests:**
   - Unit tests for utilities and repositories
   - Widget tests for screens
   - Integration tests for flows

## 🎯 Quick Wins

Want to see immediate results? Try these:

### 1. Customize the Welcome Screen

Edit `lib/features/auth/presentation/welcome_screen.dart`:
- Change the onboarding messages
- Add your own icons
- Modify the colors

### 2. Build a Simple Screen

Create a new feature screen and add it to the router:

```dart
// lib/features/test/my_screen.dart
import 'package:flutter/material.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Text('This is my custom screen!'),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Click Me',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button clicked!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Test Shared Widgets

Create a widget showcase screen to see all components:

```dart
// lib/features/test/widget_showcase_screen.dart
import 'package:flutter/material.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/subject_chip.dart';
import '../../shared/widgets/score_circle.dart';
import '../../shared/widgets/streak_ring.dart';

class WidgetShowcaseScreen extends StatelessWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Buttons', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            AppButton(text: 'Primary Button', onPressed: () {}),
            const SizedBox(height: 8),
            AppButton(text: 'Outlined Button', onPressed: () {}, isOutlined: true),
            const SizedBox(height: 8),
            AppButton(text: 'Loading', onPressed: () {}, isLoading: true),
            
            const SizedBox(height: 32),
            Text('Cards', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            AppCard(child: Text('This is a card')),
            
            const SizedBox(height: 32),
            Text('Chips', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                SubjectChip(label: 'Mathematics', isSelected: true),
                SubjectChip(label: 'English'),
                SubjectChip(label: 'Chemistry'),
              ],
            ),
            
            const SizedBox(height: 32),
            Text('Score Circle', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Center(child: ScoreCircle(score: 75, label: 'Score')),
            
            const SizedBox(height: 32),
            Text('Streak Ring', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Center(child: StreakRing(currentStreak: 7)),
          ],
        ),
      ),
    );
  }
}
```

## 💡 Pro Tips

1. **Use hot reload** (`r`) frequently while developing UI
2. **Check the console** for Dio logs to debug API calls
3. **Use Flutter DevTools** to inspect widget tree and state
4. **Read the PRD** to understand the full product vision
5. **Start small** - implement one feature at a time
6. **Test on real devices** - especially for offline functionality

## 🆘 Need Help?

- Check `IMPLEMENTATION_GUIDE.md` for detailed instructions
- Review `PROJECT_STATUS.md` for current progress
- See `README_FLUTTER_STRUCTURE.md` for architecture details
- Look at existing screens for code patterns

## 🎉 You're Ready!

The foundation is complete. Now it's time to build out the features and bring NaijaPaper to life!

**Happy coding! 🚀**
