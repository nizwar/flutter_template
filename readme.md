# NFlutter Template
This project using NFlutter Template (https://github.com/nizwar/flutter_template.git) with NullSafety Support!

Before we start, Use these plugins to make sure everything's setup!
```yaml
  dio: any
  provider: any
  shimmer: any
  cached_network_image: any
  shared_preferences: any
  ndialog: any

  #I do realized post bugs monitor is the most important once developing apps, 
  firebase_core: any
  firebase_analytics: any
  firebase_crashlytics: any
  firebase_performance: any
``` 

Run `flutter pub upgrade --null-safety` to fetch all newest plugin versions.

Run `flutterfire configure` to initialize Firebase project (Make sure to change package name first)

## Widget Things!
### Custom Divider
You can use `ColumnDivider` and `RowDivider` to make distance between Widgets, default space = 10 (you can change it on customDivider.dart)

### Shimmer
We got `ShimmerObject`, `ShimmeringObject`, `ShimmerContainer`, you need to group your `ShimmerObjects` / or another object using `ShimmerContainer` to make it Shimmer, if you want to directly make a shimmering object, use `ShimmeringObject`.

### Custom Image
Just simple image widget using `cached_network_image`, you can call it easily using `CustomImage`!

### Custom Card
Need more shadow from regular `Card`? use `CustomCard`!

## Another Things!
### HttpConnection
`HttpConnection` is an Abstract Class, you need to extends to use it, but don't worry, it much easier than you think, let me give you an example codes here!

```dart
    class UserHttp extends HttpConnection{
        // We store context to HttpConnection so we can show
        // Dialog, Reach Providers (i recommended to store it into 
        // HttpConnection, so you can reach providers in every 
        //extended class), etc.
        UserHttp(BuildContext context) : super(context);

        //Lets make login function
        Future<User> login({String username, String password}) async {
            //post is came from HttpConnection's Function
            var resp = await post<ApiResponse>(endpoint + "/login", body:{"username": username, "password": password});

            //ApiResponse is my template Models (you can custom with yours in https/httpConnection.dart).
            //e.g in this case, my api response will show like this
            //{
            //  success : true,
            //  message : "Success",
            //  data : {"name" : "nizwar", blablablabla},
            //}
            //so look at ApiResponse on https/httpConnection.dart

            //Simple validation, if it true, return with data
            if(resp.success) return User.fromJson(resp.data);            

            return null;
        }
    }
```

### Preferences
`Preferences` is a simple class to help you manage SharedPreferences.

```dart
    Future initData() async {
        Preferences pref = await Preferences.instance();
        //Look at utils/preferences.dart
        //You'll find token and saveToken function to store Token to SharedPreferences
        //on 'set' function, you can write this
        pref.token = "XXXX";

        //on 'void' function, you can write this
        pref.saveToken("XXXX");

        //to get the token simply use this
        String token = pref.token;
    }
```

### Navigations
Don't waste your time to show the screen by writing `Navigator.push(context, MaterialPageRoute (builder: blablabla))`, now you can easily use `startScreen()` or `replaceScreen()`, and simply close it by `closeScreen()`

```dart
    startScreen(context, YourScreen());
    replaceScreen(context, YourScreen());
    closeScreen(context);
```

Okay that's it, I'll update this repo if i found something!, 
By the way, Feel free to contribute and show the world your style!
