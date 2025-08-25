# Dynamic Ritual System

Bu yangi dinamik ritual tizimi Flutter ilovangizda ritual tanlash va boshqarish jarayonini yaxshilash uchun yaratilgan.

## Asosiy Xususiyatlar

### 1. RitualData Model
- Har bir ritual uchun to'liq ma'lumotlar saqlash
- JSON formatida import/export qilish imkoniyati
- Immutable data structure
- Type-safe getter metodlari

### 2. RitualDataProvider
- Barcha mavjud ritualarni markazlashtirilgan boshqarish
- Filtrlash va qidirish metodlari
- Dinamik ritual qo'shish imkoniyati

### 3. RitualCard Widget
- Qayta ishlatiluvchi ritual card komponenti
- Animatsiyalar va interaktivlik
- Compact va full-size versiyalari

## Foydalanish

### Asosiy Ritual Tanlash

```dart
import 'package:your_app/shared/models/ritual_data.dart';
import 'package:your_app/shared/widgets/ritual_card.dart';

// Barcha mavjud ritualarni olish
final rituals = RitualDataProvider.availableRituals;

// RitualCard widgetini ishlatish
RitualCard(
  ritual: ritual,
  isSelected: selectedRitual?.id == ritual.id,
  onTap: () => onRitualSelected(ritual),
)
```

### Ritual Filtrlash

```dart
// Ritual turi bo'yicha filtrlash
final guidedRituals = RitualDataProvider.getRitualsByType('guided');

// Tone bo'yicha filtrlash
final dreamyRituals = RitualDataProvider.getRitualsByTone('dreamy');

// Ko'p kriteriyalar bo'yicha filtrlash
final filteredRituals = RitualDataProvider.filterRituals(
  ritualType: 'guided',
  tone: 'dreamy',
  voice: 'male',
  duration: '5',
);
```

### Ritual Ma'lumotlarini Olish

```dart
final ritual = RitualDataProvider.getRitualById('sleep_manifestation');

// Individual sozlamalarni olish
final ritualType = ritual?.ritualType;
final tone = ritual?.tone;
final voice = ritual?.voice;
final duration = ritual?.duration;

// Yoki umumiy metod orqali
final setting = ritual?.getSetting('ritualType');
```

### Yangi Ritual Qo'shish

```dart
// RitualDataProvider.availableRituals ro'yxatiga yangi ritual qo'shish
const newRitual = RitualData(
  id: 'custom_ritual',
  title: 'Custom Ritual',
  subtitle: 'Your custom ritual description',
  description: 'Detailed description of your custom ritual',
  primaryColor: Color(0xFF123456),
  secondaryColor: Color(0xFF789ABC),
  icon: Icons.star,
  gradient: LinearGradient(
    colors: [Color(0xFF123456), Color(0xFF789ABC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  defaultSettings: {
    'ritualType': ['guided'],
    'tone': ['dreamy'],
    'voice': ['female'],
    'duration': ['10'],
  },
);
```

## Fayllar Tuzilishi

```
lib/
├── shared/
│   ├── models/
│   │   └── ritual_data.dart          # RitualData model va RitualDataProvider
│   └── widgets/
│       └── ritual_card.dart          # RitualCard va CompactRitualCard widgetlari
└── pages/
    └── generator/
        └── steps/
            └── ritual_step.dart      # Asosiy ritual tanlash sahifasi
```

## Xususiyatlar

### RitualData Model
- ✅ JSON serialization/deserialization
- ✅ Immutable data structure
- ✅ Type-safe getters
- ✅ Copy with metodlari
- ✅ Equality va hashCode

### RitualDataProvider
- ✅ Markazlashtirilgan ritual boshqaruvi
- ✅ Filtrlash metodlari
- ✅ Qidirish metodlari
- ✅ Statistika metodlari

### RitualCard Widget
- ✅ Animatsiyalar
- ✅ Interaktivlik
- ✅ Responsive design
- ✅ Customization options

## Keyingi Qadamlar

1. **API Integration**: Ritual ma'lumotlarini serverdan yuklash
2. **Local Storage**: Foydalanuvchi tanlovlarini saqlash
3. **Analytics**: Ritual tanlovlarini kuzatish
4. **A/B Testing**: Turli ritual variantlarini sinab ko'rish
5. **Personalization**: Foydalanuvchi xohishlariga asoslangan tavsiyalar

## Misol

```dart
class RitualSelectionPage extends StatefulWidget {
  @override
  _RitualSelectionPageState createState() => _RitualSelectionPageState();
}

class _RitualSelectionPageState extends State<RitualSelectionPage> {
  RitualData? selectedRitual;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Ritual tanlash
          ...RitualDataProvider.availableRituals.map((ritual) => 
            RitualCard(
              ritual: ritual,
              isSelected: selectedRitual?.id == ritual.id,
              onTap: () => setState(() => selectedRitual = ritual),
            ),
          ),
          
          // Tanlangan ritual ma'lumotlari
          if (selectedRitual != null)
            Container(
              padding: EdgeInsets.all(16),
              child: Text(selectedRitual!.description),
            ),
        ],
      ),
    );
  }
}
```

Bu tizim sizga ritual tanlash jarayonini to'liq dinamik va moslashuvchan qilish imkonini beradi. 