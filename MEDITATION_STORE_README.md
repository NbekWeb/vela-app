# MeditationStore Documentation

## Overview
`MeditationStore` is a separate store that handles all meditation-related functionality, including profile data, ritual settings, and API calls for meditation features.

## Features
- **Meditation Profile Management**: Store and manage meditation profile data
- **Ritual Settings Storage**: Save and load ritual preferences (type, tone, duration, plan type)
- **Generated Data Storage**: Store generated meditation data
- **API Integration**: Handle meditation-related API calls

## Usage

### 1. Accessing the Store
```dart
// Using Provider
final meditationStore = context.read<MeditationStore>();
// or
final meditationStore = Provider.of<MeditationStore>(context, listen: false);

// Using Consumer
Consumer<MeditationStore>(
  builder: (context, store, child) {
    return Text('Loading: ${store.isLoading}');
  },
)
```

### 2. Post Combined Profile
```dart
await meditationStore.postCombinedProfile(
  gender: 'male',
  dream: 'Peaceful life',
  goals: 'Inner peace',
  ageRange: '25-35',
  happiness: 'Very happy',
  name: 'My Meditation',
  description: 'A calming meditation',
  ritualType: 'morning',
  tone: 'calm',
  voice: 'male',
  duration: '5',
  planType: 1,
);
```

### 3. Ritual Settings Management
```dart
// Save ritual settings
await meditationStore.saveRitualSettings(
  ritualType: 'morning',
  tone: 'calm',
  duration: '5',
  planType: 1,
);

// Load ritual settings
await meditationStore.loadRitualSettings();

// Clear ritual settings
await meditationStore.clearRitualSettings();
```

### 4. Accessing Stored Data
```dart
// Get meditation profile
final profile = meditationStore.meditationProfile;

// Get ritual settings
final ritualType = meditationStore.storedRitualType;
final tone = meditationStore.storedTone;
final duration = meditationStore.storedDuration;
final planType = meditationStore.storedPlanType;

// Get generated data
final generatedData = meditationStore.generatedData;

// Check loading state
final isLoading = meditationStore.isLoading;

// Get error
final error = meditationStore.error;
```

### 5. Setting Data
```dart
// Set meditation profile
meditationStore.setMeditationProfile(profileData);

// Set generated data
meditationStore.setGeneratedData(data);

// Clear error
meditationStore.clearError();
```

## Integration with Main App

The `MeditationStore` is already integrated in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize stores
  final authStore = AuthStore();
  final meditationStore = MeditationStore();
  
  await authStore.initialize();
  await meditationStore.initialize();
  
  runApp(MyApp(authStore: authStore, meditationStore: meditationStore));
}
```

## Migration from AuthStore

If you were previously using meditation functionality from `AuthStore`, update your code:

**Before:**
```dart
final authStore = context.read<AuthStore>();
await authStore.postCombinedProfile(...);
```

**After:**
```dart
final meditationStore = context.read<MeditationStore>();
await meditationStore.postCombinedProfile(...);
```

## Benefits of Separation

1. **Single Responsibility**: Each store has a clear, focused purpose
2. **Better Organization**: Meditation logic is separated from authentication logic
3. **Easier Testing**: Can test meditation functionality independently
4. **Improved Maintainability**: Changes to meditation features don't affect auth logic
5. **Better Performance**: Only widgets that need meditation data will rebuild 