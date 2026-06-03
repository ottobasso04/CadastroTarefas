import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../models/usuario.dart';
import '../services/tarefa_service.dart';
import '../services/usuario_service.dart';
import 'tarefa_detail_screen.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Usuario> _usuarios = [];
  List<Tarefa> _tarefas = [];
  Usuario? _usuarioSelecionado;
  bool _loadingUsuarios = true;
  bool _loadingTarefas = false;

  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  List<int> _membrosSelecionados = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    try {
      final lista = await UsuarioService.listar();
      setState(() { _usuarios = lista; _loadingUsuarios = false; });
    } catch (_) {
      setState(() => _loadingUsuarios = false);
    }
  }

  Future<void> _carregarTarefas(int usuarioId) async {
    setState(() => _loadingTarefas = true);
    try {
      final lista = await TarefaService.listarPorUsuario(usuarioId);
      setState(() { _tarefas = lista; _loadingTarefas = false; });
    } catch (_) {
      setState(() => _loadingTarefas = false);
    }
  }

  Future<void> _salvarTarefa() async {
    if (_tituloCtrl.text.isEmpty || _usuarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe título e administrador')));
      return;
    }
    try {
      final membros = _usuarios.where((u) => _membrosSelecionados.contains(u.id)).toList();
      await TarefaService.salvar(Tarefa(
        titulo: _tituloCtrl.text,
        descricao: _descCtrl.text,
        administrador: _usuarioSelecionado,
        membros: membros,
      ));
      _tituloCtrl.clear(); _descCtrl.clear(); _membrosSelecionados = [];
      Navigator.pop(context);
      _carregarTarefas(_usuarioSelecionado!.id!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  void _mostrarFormulario() {
    Usuario? adminLocal;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nova Tarefa', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _campo(_tituloCtrl, 'Título'),
                _campo(_descCtrl, 'Descrição'),
                const Text('Administrador', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                const SizedBox(height: 8),
                DropdownButtonFormField<Usuario>(
                  value: adminLocal,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true, fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                  items: _usuarios.map((u) => DropdownMenuItem(value: u, child: Text(u.nome))).toList(),
                  onChanged: (v) { setModalState(() => adminLocal = v); _usuarioSelecionado = v; },
                ),
                const SizedBox(height: 16),
                const Text('Membros', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                ..._usuarios.map((u) => CheckboxListTile(
                  value: _membrosSelecionados.contains(u.id),
                  title: Text(u.nome, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  activeColor: const Color(0xFF10B981),
                  onChanged: (v) => setModalState(() {
                    if (v == true) _membrosSelecionados.add(u.id!);
                    else _membrosSelecionados.remove(u.id);
                  }),
                )),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _salvarTarefa,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Salvar', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController ctrl, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Color(0xFF64748B)),
        filled: true, fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Tarefas', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          if (!_loadingUsuarios)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<Usuario>(
                value: _usuarioSelecionado,
                hint: const Text('Selecionar usuário', style: TextStyle(color: Color(0xFF64748B))),
                isExpanded: true,
                dropdownColor: const Color(0xFF1E293B),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: _usuarios.map((u) => DropdownMenuItem(value: u, child: Text(u.nome))).toList(),
                onChanged: (u) {
                  setState(() { _usuarioSelecionado = u; _tarefas = []; });
                  if (u?.id != null) _carregarTarefas(u!.id!);
                },
              ),
            ),
          Expanded(
            child: _loadingTarefas
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
                : _usuarioSelecionado == null
                    ? const Center(child: Text('Selecione um usuário', style: TextStyle(color: Color(0xFF64748B))))
                    : _tarefas.isEmpty
                        ? const Center(child: Text('Nenhuma tarefa', style: TextStyle(color: Color(0xFF64748B))))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _tarefas.length,
                            itemBuilder: (_, i) {
                              final t = _tarefas[i];
                              return GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => TarefaDetailScreen(tarefa: t, usuarios: _usuarios))).then((_) {
                                  if (_usuarioSelecionado?.id != null) _carregarTarefas(_usuarioSelecionado!.id!);
                                }),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: t.status ? const Color(0xFF10B981).withOpacity(0.4) : Colors.transparent),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(t.status ? Icons.check_circle : Icons.radio_button_unchecked,
                                          color: t.status ? const Color(0xFF10B981) : const Color(0xFF64748B)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(t.titulo, style: TextStyle(
                                              color: t.status ? const Color(0xFF64748B) : Colors.white,
                                              fontWeight: FontWeight.w600,
                                              decoration: t.status ? TextDecoration.lineThrough : null,
                                            )),
                                            if (t.descricao.isNotEmpty)
                                              Text(t.descricao, maxLines: 1, overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}