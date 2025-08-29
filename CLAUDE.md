# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Korean household expense tracking Flutter web application called "Dobu" (가계부). It uses a multi-platform Flutter architecture with database persistence, cloud backup via Supabase, and data visualization features.

## Key Development Commands

- **Build & Run**: `cd src && flutter run -d chrome` (for web development)
- **Code Generation**: `cd src && dart run build_runner build` (for Drift database code generation)
- **Analysis**: `cd src && flutter analyze`
- **Testing**: `cd src && flutter test`
- **Clean Build**: `cd src && flutter clean && flutter pub get`

## Architecture Overview

### State Management
- **Riverpod**: Primary state management solution used throughout the app
- **Provider Pattern**: Database and repository providers are centralized
- Key providers: `appDatabaseProvider`, expense/budget/category providers

### Database Layer (Drift ORM)
- **Database**: `lib/db/database.dart` - Main database configuration
- **Tables**: Located in `lib/db/tables/` (expenses, budgets, categories)
- **Code Generation**: Drift generates `database.g.dart` - run build_runner after schema changes
- **Repositories**: `lib/repositories/` - Data access layer abstracting database operations

### Navigation
- **Main Navigator**: `lib/main_navigator.dart` with persistent bottom navigation
- **Screens**: Home, Insights (charts), and Backup functionality
- **Bottom Navigation**: Uses `persistent_bottom_nav_bar` package

### Core Features
1. **Expense Tracking**: Add, edit, delete expenses with categories
2. **Budget Management**: Set and track monthly budgets
3. **Data Visualization**: Charts using `fl_chart` (pie charts, bar charts)
4. **Cloud Backup**: Supabase integration for data sync
5. **Localization**: Korean language support with date formatting

### Project Structure
- **`lib/screens/`**: Main application screens
- **`lib/widgets/`**: Reusable UI components organized by screen
- **`lib/providers/`**: Riverpod providers for state management
- **`lib/repositories/`**: Data access layer
- **`lib/models/`**: Data models
- **`lib/services/`**: Business logic services
- **`lib/constants/`**: Static data (category definitions)

### Environment Setup
- **Environment Variables**: Uses `.env` file for Supabase configuration
- **Supabase**: Authentication and cloud storage backend
- **Localization**: Korean (`ko`) and English (`en`) support

### Database Schema
- **Categories**: Pre-populated with Korean expense categories
- **Expenses**: Core expense tracking with category references
- **Budgets**: Monthly budget management

## Development Notes

- The project is located in the `src/` subdirectory, not the root
- Always run Flutter commands from the `src/` directory
- After making database schema changes, run `dart run build_runner build`
- The app uses Korean language defaults and currency formatting
- Web target is the primary platform (Chrome for development)

## Code Style Guidelines

**IMPORTANT**: These style guidelines apply to ALL code written in this project, regardless of file type or location.

### Line Spacing for Code Blocks
Always add blank lines between code blocks of different semantic purposes to improve readability:

- **Between variable declarations and conditional statements**
- **Between conditional statements and loops**
- **Between loops and function calls**
- **Before return statements**
- **Between different logical groups of operations**

#### Examples:

**❌ Bad (no spacing):**
```dart
Future<void> processExpense() async {
  final amount = parseAmount(input);
  final category = getCategory();
  if (amount <= 0) {
    throw ValidationError('Invalid amount');
  }
  for (final rule in validationRules) {
    rule.validate(amount);
  }
  final expense = createExpense(amount, category);
  return saveExpense(expense);
}
```

**✅ Good (proper spacing):**
```dart
Future<void> processExpense() async {
  // Variable declarations
  final amount = parseAmount(input);
  final category = getCategory();

  // Validation logic
  if (amount <= 0) {
    throw ValidationError('Invalid amount');
  }

  // Processing loop
  for (final rule in validationRules) {
    rule.validate(amount);
  }

  // Final operations
  final expense = createExpense(amount, category);
  
  return saveExpense(expense);
}
```

This spacing convention helps distinguish between different logical sections of code and improves overall code readability.

### Comments Guidelines
**IMPORTANT**: These comment rules apply to ALL code in this project - widgets, services, providers, repositories, models, etc.

Comments should be used sparingly and only when necessary. Follow these principles:

- **Self-documenting code is preferred**: Use descriptive function names, variable names, and clear logic structure
- **Avoid obvious comments**: Don't comment what the code clearly shows
- **Comments indicate complexity**: If you need comments, consider if the function name or structure could be improved instead
- **Use comments only for**:
  - Complex business logic that isn't immediately clear from the code
  - Non-obvious algorithmic decisions
  - External API constraints or workarounds
  - Temporary solutions with explanations

#### Examples:

**❌ Bad (unnecessary comments):**
```dart
// Get user data
final userData = await fetchUser();

// Check if user exists
if (userData == null) {
  return null;
}

// Calculate total amount
final total = userData.expenses.fold(0, (sum, expense) => sum + expense.amount);
```

**✅ Good (self-documenting code):**
```dart
final userData = await fetchUser();

if (userData == null) {
  return null;
}

final total = userData.expenses.fold(0, (sum, expense) => sum + expense.amount);
```

**✅ Acceptable comment (complex business logic):**
```dart
// Supabase requires manual upsert handling due to composite key limitations
final existingRecord = await findExistingRecord(userId, monthKey);
if (existingRecord != null) {
  await updateRecord(existingRecord.id, newData);
} else {
  await insertRecord(newData);
}
```