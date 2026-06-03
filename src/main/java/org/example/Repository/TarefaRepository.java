package org.example.Repository;

import org.example.model.Tarefa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface TarefaRepository extends JpaRepository<Tarefa, Long> {
    @Query("SELECT DISTINCT t FROM Tarefa t LEFT JOIN t.membros m WHERE t.administrador.id = :id OR m.id = :id")
    List<Tarefa> findByUsuarioEnvolvido(@Param("id") Long id);
}
