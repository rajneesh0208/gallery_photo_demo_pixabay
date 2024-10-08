import 'dart:convert';
import 'package:http/http.dart' as http;

class PixabayService {
  final String apiKey = '46403321-567708429a9a6d639bdbe917d';
  final String baseUrl = 'https://pixabay.com/api/';

  Future<List<dynamic>> fetchImages(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl?key=$apiKey&image_type=photo&per_page=20&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['hits'];
    } else {
      throw Exception('Failed to load images');
    }
  }
}
