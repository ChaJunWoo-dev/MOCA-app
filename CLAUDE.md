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