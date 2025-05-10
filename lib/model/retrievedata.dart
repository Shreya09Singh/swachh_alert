import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadReport() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String imageUrl = prefs.getString('imageUrl') ?? 'No Image';
  String location = prefs.getString('location') ?? 'No Location';
  String category = prefs.getString('category') ?? 'selected category';

  String description = prefs.getString('description') ?? 'No Description';

  print('Image URL: $imageUrl');
  print('Location: $location');
  print('Category: $category');
  print('Description: $description');
}
