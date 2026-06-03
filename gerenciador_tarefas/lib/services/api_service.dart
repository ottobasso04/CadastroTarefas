import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔧 TROQUE PELO IP DA SUA MÁQUINA (não use localhost em dispositivo físico)
  // static const String baseUrl = 'http://10.0.2.2:8081'; // Emulador Android
  // static const String baseUrl = 'http://192.168.1.12:8081'; // Dispositivo físico
  static const String baseUrl = 'http://localhost:8081';

  static Map<String, String> get headers => {'Content-Type': 'application/json'};

  static Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'), headers: headers);
    if (res.statusCode == 200) return jsonDecode(utf8.decode(res.bodyBytes));
    throw Exception('GET $path falhou: ${res.statusCode}');
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(Uri.parse('$baseUrl$path'), headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) return jsonDecode(utf8.decode(res.bodyBytes));
    throw Exception('POST $path falhou: ${res.statusCode}');
  }

  static Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final res = await http.patch(Uri.parse('$baseUrl$path'), headers: headers, body: jsonEncode(body));
    if (res.statusCode == 200) return jsonDecode(utf8.decode(res.bodyBytes));
    throw Exception('PATCH $path falhou: ${res.statusCode}');
  }
}