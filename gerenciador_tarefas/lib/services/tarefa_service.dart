import '../models/tarefa.dart';
import 'api_service.dart';

class TarefaService {
  static Future<Tarefa> buscarPorId(int id) async {
    final data = await ApiService.get('/Tarefas/$id');
    return Tarefa.fromJson(data);
  }

  static Future<List<Tarefa>> listarPorUsuario(int usuarioId) async {
    final data = await ApiService.get('/Tarefas/usuario/$usuarioId');
    return (data as List).map((e) => Tarefa.fromJson(e)).toList();
  }

  static Future<Tarefa> salvar(Tarefa tarefa) async {
    final data = await ApiService.post('/Tarefas', tarefa.toJson());
    return Tarefa.fromJson(data);
  }

  static Future<Tarefa> atualizar(Tarefa tarefa) async {
    final data = await ApiService.patch('/Tarefas', tarefa.toJson());
    return Tarefa.fromJson(data);
  }
}