# Http Connections
All API calls are managed through the HTTP connections defined in this section. These connections handle communication between the app and the backend, ensuring data is fetched and sent securely.

The base URL for your API is declared in the `environment`, which means you don't need to specify the full URL for each request. Instead, you only need to provide the path relative to the base URL.

For example, if the base URL is https://api.example.com, and you want to make a request to the auth/login endpoint, you simply use the path:

## API Requests
Below is an example of how to use the HttpConnection class for making an API call, specifically for logging in a user:

### Simple Request
For consistency and clarity, file names should follow a strict naming convention. For files related to API calls, ensure to add the _http suffix to indicate that all API processes will be handled within these files.

Example : A file for handling user-related HTTP requests should be named `user_http.dart.` and the class name will be UserHttp
```dart
class UserHttp extends HttpConnection {
    // The context is passed to the HttpConnection constructor,
    // which allows access to providers or any data that requires context.
    UserHttp(BuildContext context) : super(context);

    // Example: Login function
    Future<User> login({String username, String password}) async {
        // The 'post' method is inherited from HttpConnection.
        var resp = await post<ApiResponse>(endpoint + "/login", body: {
            "username": username,
            "password": password
        });

        // ApiResponse is a custom model defined in https/httpConnection.dart.
        // Example API response:
        // {
        //   success: true,
        //   message: "Success",
        //   data: {"name": "nizwar", ...},
        // }

        // Simple validation: if the response is successful, return a User object.
        if (resp.success) {
            return User.fromJson(resp.data);
        }

        return null; // Return null if login fails.
    }
}
```

#### Key Notes:
1. HttpConnection: A base class for handling HTTP requests. It provides methods like post for making API calls.
2. UserHttp: An example of extending HttpConnection to handle user-related actions, such as logging in.
3. ApiResponse: A custom model used for wrapping API responses, allowing easy access to success, message, and data.
4. User.fromJson: A method that deserializes the response data into a User model.
5. By centralizing all API interactions within this structure, it ensures consistent, reusable, and maintainable code for handling network requests.


### Multipart Form
To handle file uploads, you can use the post method with FormData to send the file as part of the request body. Here’s an example of how to upload a file:
```dart
ApiResponse? response = await post(
      "api/upload",
      body: FormData.fromMap({ 
        "file": await MultipartFile.fromFile(file.path),
        "other_post_body": "Dummy data",
      }),
    );
```

### Custom URL
In some cases, you may need to make API calls to an endpoint outside of your base API. This can be easily handled by setting a custom base URL before making the request.

To do so, simply assign the custom URL to the baseUrl property of the dio instance before making any API calls:

```dart
updateBaseUrl("https://another-base-url.com");// Set custom URL
```

#### Custom Base URL in a Separate Class
If you need to make API calls to a different domain within a specific class, you can create a new class that extends HttpConnection and specify a custom base URL directly in the constructor. This allows you to use a different base URL for that particular class while keeping the default base URL for other parts of your application.

```dart
class AnotherClassWithDifferentBaseURL extends HttpConnection {
  // Provide a custom base URL for this class
  AnotherClassWithDifferentBaseURL(BuildContext context) : super(context, baseUrl: "https://another-base-url.com");
}
```

### Automate the Authorization
To automate the process of adding authorization headers to every API request, you can adjust the `_preRequestHeaders` method in the `lib/core/https/http_connection.dart` file. This method will automatically append the necessary headers, such as the authorization token, to every request before it is sent.

Here’s an example of how to add an authorization token to the request headers:

```dart
Map<String, String>? _preRequestHeaders(Map<String, String>? headers) {
  // Retrieve the token from your UserProvider (uncomment and adjust as necessary)
  // var userProvider = UserProvider.read(context);
  
  // Check if the token is available, and if so, add it to the headers
  if (userProvider.auth?.token != null) {
    if (headers != null) {
      // Add the Authorization header if headers already exist
      headers.addEntries([MapEntry("Authorization", "Bearer ${userProvider.auth?.token}")]);
    } else {
      // Otherwise, create a new header map with the Authorization header
      headers = {"Authorization": "Bearer ${userProvider.auth?.token}"};
    }
  }
  
  // Return the updated headers
  return headers;
}
```

### Error Handling
All API errors are thrown as exceptions of type HttpErrorConnection. This custom exception provides details about the error, including:

1. Status Code: The HTTP status code returned by the server.
2. Status Message: A message describing the error.
3. Response: The raw response data from the server.

You can adjust the data structure of HttpErrorConnection to align with how your API represents errors.

```dart
try {
  // API request process
} on HttpErrorConnection catch (e) {
  // Handle the error here
  print("Error occurred: ${e.message}");
  print("Status code: ${e.statusCode}");
  print("Response: ${e.response}");
}
```

#### Best Practices for Error Handling:
1. Never Show UI Inside HttpConnection:

    Do not show dialogs, navigate to new screens, or perform any UI-related tasks directly within the HttpConnection. Keep the logic for handling UI-level responses at the widget level.
2. Centralized Error Catching:

    Use try-catch blocks at the widget level to catch and handle errors gracefully. 
    
For example:
```dart
Future<void> loginUser() async {
  try {
    await userHttp.login(username: "user", password: "pass");
  } on HttpErrorConnection catch (e) {
    showErrorDialog(context, e.message); // Example of handling errors in the widget
  }
}
```
Customize Error Feedback:
You can modify the HttpErrorConnection class to extract additional details from your API's error responses, such as specific error codes or messages.