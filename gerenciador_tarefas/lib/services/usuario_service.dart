import '../models/usuario.dart';
import 'api_service.dart';

class UsuarioService {
  static Future<List<Usuario>> listar() async {
    final data = await ApiService.get('/Usuarios');
    return (data as List).map((e) => Usuario.fromJson(e)).toList();
  }

  static Future<Usuario> buscarPorId(int id) async {
    final data = await ApiService.get('/Usuarios/$id');
    return Usuario.fromJson(data);
  }

  static Future<Usuario> salvar(Usuario usuario) async {
    final data = await ApiService.post('/Usuarios', usuario.toJson());
    return Usuario.fromJson(data);
  }
}