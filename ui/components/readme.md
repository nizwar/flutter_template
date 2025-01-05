# Components
Components are reusable widgets designed to prevent repetitive code and simplify the development process. They can be easily called and utilized anywhere they are needed, promoting consistency and maintainability across the project.

### Custom Divider
Utilize `ColumnDivider` and `RowDivider` to create spacing between widgets. The default spacing is set to 10, but you can modify it in `ui/components/custom_divider.dart`.

### Shimmer Effects
Our shimmer utilities include `ShimmerObject`, `ShimmeringObject`, and `ShimmerContainer`. 

#### To implement shimmer effects:

Use `ShimmerContainer` to group your `ShimmerObjects` or any other widgets.
For standalone shimmering widgets, opt for `ShimmeringObject`.

### Custom Image
The `CustomImage` widget simplifies the process of displaying images using `cached_network_image`. It provides an easy and efficient solution for handling images.

### Custom Card
Need enhanced shadow effects compared to the default Card widget? Use CustomCard for a more visually appealing result.

### Paginator Page
The Paginator Page widget provides a quick and efficient way to implement paginated lists in your application. It simplifies handling pagination with minimal configuration and allows seamless integration with API responses.

#### Features:
- `future`: A function that returns a `List` of the specified type, with pagination controlled by the page and limit parameters.
- `itemBuilder`: A builder function that customizes each list item, utilizing index and T item to define the UI for each data entry.
- `emptyBuilder`: A widget builder displayed when the list is empty.
- `loadingBuilder`: A widget builder shown during initial loading or when a refresh is triggered.
- `limit`: Specifies the number of items per page. This value is passed to the future function for pagination.
- `prefixChildren`: A list of widgets displayed before the paginated data items, useful for adding headers or introductory content.
- `padding`: Configures the padding around the list for proper layout and spacing.
- `paginated`: A flag indicating whether the list supports pagination. If false, no pull-to-refresh or load-more functionality will be enabled.
- `refreshController`: A controller that manages refresh and load-more actions to handle user interactions with the paginated list.

#### Example:
```dart 
PaginatorPage<String>(
  future: (page, limit) async {
    // Example API call that returns a paginated list of items.
    return await fetchData(page: page, limit: limit); 
  },
  itemBuilder: (context, index, item) {
    // Custom item builder for the list.
    return ListTile(
      title: Text(item),
    );
  },
  emptyBuilder: (context) {
    return Center(child: Text("No items found."));
  },
  loadingBuilder: (context) {
    return Center(child: CircularProgressIndicator());
  },
  limit: 10, // Number of items per page
  prefixChildren: [
    Padding(
      padding: EdgeInsets.all(8),
      child: Text("Paginated List"),
    ),
  ],
  padding: EdgeInsets.all(8),
  paginated: true,
  refreshController: RefreshController(initialRefresh: false),
)
```

This widget abstracts the pagination logic, making it easier to integrate paginated data while maintaining customization flexibility for different use cases.
