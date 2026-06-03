package org.example.Controller;

import org.example.Service.TarefaService;
import org.example.model.Tarefa;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/Tarefas")
@CrossOrigin("*")
public class TarefaController {
    private final TarefaService tarefaService;
    public TarefaController(TarefaService tarefaService){
        this.tarefaService = tarefaService;
    }

    @PostMapping
    public Tarefa salvar(@RequestBody Tarefa tarefa){
        return tarefaService.salvar(tarefa);
    }

    @PatchMapping
    public Tarefa atualizar(@RequestBody Tarefa tarefa){
        return tarefaService.atualizar(tarefa);
    }

    @GetMapping("/{id}")
    public Tarefa consultar(@PathVariable Long id){
        return tarefaService.findById(id);
    }

    @GetMapping("/usuario/{usuarioId}")
    public List<Tarefa> listarTarefasDoUsuario(@PathVariable Long usuarioId) {
        return tarefaService.listarPorUsuario(usuarioId);
    }
}
