# Screens
A screen represents the main user interface that is displayed to the user. Every screen should start with a Scaffold widget as its base structure, which provides the framework for implementing app bars, drawers, floating action buttons, and more.

## AI Instructions (Screens)
When editing or adding screens, follow these rules:
1. Always start with `Scaffold` and keep the widget tree shallow.
2. Use `theme(context)`, `textTheme(context)`, and `colorScheme(context)` for styling.
3. Reuse components from `lib/ui/components` before creating new widgets.
4. Keep screen widgets small; extract sub-widgets for clarity and reuse.
5. Handle API errors in the widget layer and display user-friendly UI states.

## Recommended Structure
- `Scaffold`
- `SafeArea`
- `SingleChildScrollView` (only when needed)
- Page content split into private widgets

## State Management Notes
Prefer Provider for screen-level state. Keep local providers within the screen folder when the state is not global.

## Anti-Patterns to Avoid
- Hardcoded colors or text styles
- Network calls directly in `build()`
- Massive build methods without extraction