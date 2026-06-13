# Components

Reusable widgets that prevent duplication and keep the UI consistent. Reach for these before building something new.

## AI Instructions (Components)

1. Keep components stateless unless local state is genuinely required.
2. Use theme helpers (`theme/textTheme/colorScheme(context)`) for colors and text — never hardcode.
3. Favor composability: accept `child`, `builder`, or `content` parameters.
4. Avoid coupling a component to a single screen or feature.
5. Add a short usage example when introducing a new component.

## Available components

### Custom Divider
`ColumnDivider` and `RowDivider` add spacing between widgets (default `space: 10`). Pass `color` to draw a visible line.

```dart
Column(children: [WidgetA(), const ColumnDivider(space: 16), WidgetB()]);
```

### Shimmer effects
- `ShimmerObject` — a plain placeholder box.
- `ShimmeringObject` — a box already wrapped in the shimmer animation (use standalone).
- `ShimmerContainer` — wraps arbitrary children in the shimmer animation; group several `ShimmerObject`s inside it.

### Custom Image
`CustomImage` displays remote images via `cached_network_image`, with a shimmer placeholder and an error fallback. It safely handles a null/empty `url` (shows the error widget instead of crashing) and supports `zoomOnTap`, `borderRadius`, `boxShape`, and an optional `errorAssets` image.

```dart
CustomImage(url: user.avatarUrl, height: 64, width: 64, boxShape: BoxShape.circle, zoomOnTap: true);
```

### Custom Card
`CustomCard` is an elevated surface with a softer shadow than the default `Card`. Accepts `borderRadius`, `backgroundColor`, `margin`, `padding`, `boxShadow`, and `child`.

### Adaptive Progress Indicator
`AdaptiveProgressIndicator` renders a Cupertino spinner on iOS/macOS and a Material one elsewhere. It is Web-safe (uses `defaultTargetPlatform`, not `dart:io`).

### Paginator Page
`PaginatorPage<T>` implements pull-to-refresh + infinite-scroll pagination with minimal setup, and builds rows lazily via `ListView.builder`.

#### Parameters

- `future` — `Future<List<T>> Function(int page, int limit)`; fetch one page.
- `itemBuilder` — `Widget Function(int index, T item, RefreshController controller)`; build a row.
- `emptyBuilder` — `Widget Function(BuildContext context, RefreshController controller)?`; shown when there's no data.
- `loadingBuilder` — `Widget Function(BuildContext context, RefreshController controller)?`; shown during initial load/refresh.
- `limit` — items per page (default `10`), passed to `future`.
- `prefixChildren` — widgets rendered before the data (e.g. a header).
- `padding` — list padding.
- `paginated` — enable/disable pull-up load-more (default `true`).
- `refreshController` — optional external `RefreshController`.

#### Example

```dart
PaginatorPage<String>(
  future: (page, limit) async => fetchData(page: page, limit: limit),
  itemBuilder: (index, item, controller) => ListTile(title: Text(item)),
  emptyBuilder: (context, controller) => const Center(child: Text("No items found.")),
  loadingBuilder: (context, controller) => const Center(child: AdaptiveProgressIndicator()),
  limit: 10,
  prefixChildren: const [
    Padding(padding: EdgeInsets.all(8), child: Text("Paginated List")),
  ],
  padding: const EdgeInsets.all(8),
)
```

## Design guidance

- Prefer `CustomCard` for elevated surfaces.
- Use `CustomImage` for remote images to leverage caching.
- Use the shimmer widgets for loading placeholders.
- Show `AdaptiveProgressIndicator` (or `future.showProgress(context)`) for in-flight work.
