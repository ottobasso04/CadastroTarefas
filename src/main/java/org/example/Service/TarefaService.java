package org.example.Service;

import org.example.Repository.TarefaRepository;
import org.example.Repository.UsuarioRepository;
import org.example.model.Tarefa;
import org.example.model.Usuario;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class TarefaService {
    private final TarefaRepository tarefaRepository;
    private final UsuarioRepository usuarioRepository;
    public TarefaService(TarefaRepository tarefaRepository, UsuarioRepository usuarioRepository) {
        this.tarefaRepository = tarefaRepository;
        this.usuarioRepository = usuarioRepository;
    }

    public Tarefa salvar(Tarefa tarefa) {

        if (tarefa.getAdministrador() != null && tarefa.getAdministrador().getId() != null) {
            Usuario admin = usuarioRepository.findById(tarefa.getAdministrador().getId())
                    .orElseThrow(() -> new RuntimeException("Administrador não encontrado"));
            tarefa.setAdministrador(admin);
        }

        if (tarefa.getMembros() == null) {
            tarefa.setMembros(new ArrayList<>());
        } else {
            List<Usuario> membrosCarregados = tarefa.getMembros().stream()
                    .map(membro -> usuarioRepository.findById(membro.getId())
                            .orElseThrow(() -> new RuntimeException("Membro ID " + membro.getId() + " não encontrado")))
                    .toList();
            tarefa.setMembros(new ArrayList<>(membrosCarregados));
        }

        if (tarefa.getAdministrador() != null && !tarefa.getMembros().contains(tarefa.getAdministrador())) {
            tarefa.getMembros().add(tarefa.getAdministrador());
        }

        return tarefaRepository.save(tarefa);
    }

    public Tarefa findById(Long id){
        return tarefaRepository.findById(id).orElse(null);
    }

    public Tarefa atualizar(Tarefa tarefa) {
        return tarefaRepository.save(tarefa);
    }

    public List<Tarefa> listarPorUsuario(Long usuarioId) {
        return tarefaRepository.findByUsuarioEnvolvido(usuarioId);
    }
}
