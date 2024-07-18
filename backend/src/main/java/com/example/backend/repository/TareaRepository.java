package com.example.backend.repository;
import org.springframework.stereotype.Repository;
import com.example.backend.model.Tarea;
import org.springframework.data.jpa.repository.JpaRepository;
@Repository
public interface TareaRepository extends JpaRepository<Tarea, Long> {
    long countByEstadoCompletado(boolean estadoCompletado);//Contar tareas completados
    long countByEstado(boolean estado);//Contar tareas eliminadas
}
