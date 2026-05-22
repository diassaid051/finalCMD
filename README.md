# Travel Planner 🌍

Flutter приложение для планирования путешествий.

## Функции
- 📋 Создание и управление маршрутами (Drift/SQLite)
- 🔍 Поиск мест через OpenStreetMap API (Chopper)
- 🌐 Общие маршруты с друзьями (Firebase Firestore)
- 🌙 Тёмная/светлая тема (Shared Preferences)

## Технологии
| Что | Зачем |
|-----|-------|
| Flutter + Dart | основной фреймворк |
| Riverpod | управление состоянием |
| go_router | навигация |
| Drift (SQLite) | локальная база данных |
| Chopper | HTTP запросы к API |
| Firebase Firestore | облачное хранилище |
| Shared Preferences | настройки пользователя |

## Архитектура
Проект использует Clean Architecture — три слоя:
- **UI** — экраны и виджеты
- **Domain** — модели данных и бизнес-логика  
- **Data** — работа с API, базой данных и облаком

## Установка и запуск

### Требования
- Flutter SDK 3.0+
- Dart SDK 3.0+

### Шаги
1. Клонируй репозиторий
2. Установи зависимости:
flutter pub get
3. Сгенерируй код:
flutter packages pub run build_runner build
4. Запусти приложение:
flutter run -d windows

## Структура проекта
lib/
├── app/           # Навигация (go_router)
├── core/          # База данных и сеть
├── features/
│   ├── trips/     # Маршруты
│   ├── search/    # Поиск мест
│   └── settings/  # Настройки
└── main.dart

Ibrahim DIas Baisal