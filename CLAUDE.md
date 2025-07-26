# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build and Generation
- `flutter packages get` - Install dependencies
- `dart run build_runner build` - Generate code (freezed, json_serializable, riverpod, drift)
- `dart run build_runner build --delete-conflicting-outputs` - Force regenerate all generated files
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app

### Code Quality
- `flutter analyze` - Run static analysis (excludes generated .g.dart and .freezed.dart files)
- `flutter test` - Run tests

### Localization
- Uses slang for i18n with automatic generation from JSON files in `lib/core/i18n/`
- Translations are generated to `lib/core/i18n/strings.g.dart`

### Database
- Uses Drift (SQLite) for local database with DAO pattern
- Schema changes require migration files in `lib/core/database/migrations/`
- Database models are in `lib/core/database/items/`

## Architecture Overview

This is a Flutter automotive service management application with a feature-based modular architecture that combines concepts from 1C and Domain-Driven Design (DDD).

### Hybrid Architecture: 1C + DDD
The application uses a hybrid approach combining:
- **1C concepts**: Document-centric approach (orders), references (clients, vehicles), registers (inventory, finances)
- **DDD patterns**: Bounded contexts, aggregates, composite models, repository pattern, domain services

### Architectural Layers
1. **Presentation Layer** (UI): Screens, widgets, UI state management
2. **Application Layer**: Use cases, application services, DTOs
3. **Domain Layer**: Business logic, composite models, domain services, interfaces
4. **Infrastructure Layer**: Database access (DAOs), API clients, external integrations
5. **Core Layer**: Shared utilities, constants, base classes

### Core Structure
- **Core Layer** (`lib/core/`): Shared infrastructure including database, i18n, navigation, service locator
- **Features** (`lib/features/`): Business modules organized by domain (bounded contexts)
- **Models** (`lib/models/`): Shared data models across features

### Key Features
- **References**: Client management, vehicle registry, supplier management
- **Documents**: Order management (work orders/repair orders)
- **Parts Catalog**: Integration with external parts catalogs API
- **Suppliers**: Integration with multiple supplier APIs (Armtek, etc.)
- **Settings**: Configuration management for API connections

### State Management
- Uses Riverpod for state management with code generation
- Providers are organized per feature in `providers/` subdirectories
- State classes use Freezed for immutability

### Database Architecture
- Drift (SQLite) with type-safe DAO pattern
- Composite models that combine core data with specific data
- Support for references (clients, vehicles) and documents (orders)
- Automatic migrations and schema versioning
- **ID Strategy**: Database uses integer IDs, business models use String IDs (UUID)
- Soft delete pattern with `deletedAt` field
- Reactive queries using streams

### API Integration
- Retrofit for HTTP clients with code generation
- Dio for HTTP requests with logging
- Multi-supplier architecture with configurable endpoints
- **Connection Modes**:
  - **Direct**: Direct connection to supplier APIs (development/testing)
  - **Proxy**: Through proxy server (production/security)
  - **Hybrid**: Automatic switching between modes for fault tolerance

### Code Generation Dependencies
The project heavily uses code generation for:
- **Freezed**: Immutable data classes and unions
- **json_serializable**: JSON serialization
- **Retrofit**: HTTP client interfaces
- **Riverpod**: State management providers
- **Drift**: Database DAOs and table definitions
- **Slang**: Internationalization

### Key Patterns
- Feature-based organization with screens, models, services, and providers per feature
- **Composite Model Pattern**: Combines `EntityCoreData` + `SpecificData` into business models
  - Example: `OrderModelComposite` = `EntityCoreData` + `OrderSpecificData`
  - Implements interfaces like `IDocumentEntity`, `IOrderEntity`
- Service locator pattern using get_it for dependency injection
- Repository pattern for data access through DAOs
- Clean separation between UI, business logic, and data layers
- **Model Structure**:
  - Interfaces define contracts (`IEntity`, `IDocumentEntity`)
  - Composite classes implement interfaces and encapsulate data/behavior
  - `@freezed` models for immutable data structures

### Testing Strategy
- Unit tests for business logic and data models
- Widget tests for UI components
- Integration tests for API clients and database operations

## Important Notes
- Always run code generation (`dart run build_runner build`) after modifying models, APIs, or providers
- Follow the existing feature structure when adding new functionality
- Use the composite model pattern for entities that need both core and specific data
- Ensure proper localization by adding strings to appropriate i18n JSON files
- Database changes require migration files and schema version updates
- When creating new entities, follow the established pattern:
  1. Define interface in `features/core/`
  2. Create `@freezed` data models for core and specific data
  3. Implement composite model class that combines data models
  4. Create DAO in `core/database/daos/`
  5. Add service layer in feature module
  6. Create providers for state management