import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../models/usuario.dart';
import '../services/tarefa_service.dart';

class TarefaDetailScreen extends StatefulWidget {
  final Tarefa tarefa;
  final List<Usuario> usuarios;

  const TarefaDetailScreen({super.key, required this.tarefa, required this.usuarios});

  @override
  State<TarefaDetailScreen> createState() => _TarefaDetailScreenState();
}

class _TarefaDetailScreenState extends State<TarefaDetailScreen> {
  late Tarefa _tarefa;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _tarefa = widget.tarefa;
  }

  Future<void> _alternarStatus() async {
    setState(() => _salvando = true);
    try {
      final atualizado = await TarefaService.atualizar(_tarefa.copyWith(status: !_tarefa.status));
      setState(() { _tarefa = atualizado; _salvando = false; });
    } catch (_) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao atualizar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final concluida = _tarefa.status;
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Detalhe da Tarefa', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(_tarefa.titulo,
                      style: TextStyle(
                        color: concluida ? const Color(0xFF64748B) : Colors.white,
                        fontSize: 24, fontWeight: FontWeight.bold,
                        decoration: concluida ? TextDecoration.lineThrough : null,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: concluida ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFFF59E0B).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(concluida ? 'Concluída' : 'Pendente',
                      style: TextStyle(color: concluida ? const Color(0xFF10B981) : const Color(0xFFF59E0B), fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _secao('Descrição', _tarefa.descricao.isEmpty ? 'Sem descrição' : _tarefa.descricao),
            const SizedBox(height: 16),
            _secao('Administrador', _tarefa.administrador?.nome ?? 'N/A'),
            const SizedBox(height: 16),
            const Text('Membros', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, letterSpacing: 1)),
            const SizedBox(height: 8),
            if (_tarefa.membros.isEmpty)
              const Text('Sem membros', style: TextStyle(color: Colors.white))
            else
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _tarefa.membros.map((m) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(m.nome, style: const TextStyle(color: Color(0xFF6366F1), fontSize: 13)),
                )).toList(),
              ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvando ? null : _alternarStatus,
                icon: _salvando
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Icon(concluida ? Icons.replay : Icons.check_circle_outline, color: Colors.white),
                label: Text(concluida ? 'Reabrir Tarefa' : 'Marcar como Concluída', style: const TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: concluida ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secao(String label, String valor) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, letterSpacing: 1)),
      const SizedBox(height: 4),
      Text(valor, style: const TextStyle(color: Colors.white, fontSize: 16)),
    ],
  );
}