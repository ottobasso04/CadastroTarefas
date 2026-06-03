package org.example.Controller;
import org.example.Repository.UsuarioRepository;
import org.example.Service.UsuarioService;
import org.example.model.Usuario;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/Usuarios")
@CrossOrigin("*")
public class UsuarioController {
    private UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @PostMapping
    public Usuario save(@RequestBody Usuario usuario){
        return usuarioService.save(usuario);
    }

    @GetMapping
    public List<Usuario> list(){
        return usuarioService.list();
    }

    @GetMapping("/{id}")
    public Usuario findById(@PathVariable Long id){
        return usuarioService.findById(id);
    }

}
