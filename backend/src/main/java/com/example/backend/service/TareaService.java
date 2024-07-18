package com.example.backend.service;

import com.example.backend.model.Tarea;
import com.example.backend.repository.TareaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class TareaService {
    @Autowired
    private TareaRepository tareaRepository;

    // listar todas las tareas
    public List<Tarea> listaTodasTareas() {
        return tareaRepository.findAll();
    }

    public Optional<Tarea> buscarTareaId(Long id) {
        return tareaRepository.findById(id);
    }

    //añadir una nueva tarea.
    public Tarea creatTarea(Tarea tarea) {
        tarea.setEstado(true);  //valor por defecto a true
        return tareaRepository.save(tarea);
    }

    public Optional<Tarea> editarTarea(Long id, Tarea DetallesTarea) {
        return tareaRepository.findById(id).map(tarea -> {
            tarea.setNombre(DetallesTarea.getNombre());
            tarea.setEstado(DetallesTarea.isEstado());
            tarea.setEstadoCompletado(DetallesTarea.isEstadoCompletado());
            tarea.setDescripcion(DetallesTarea.getDescripcion());
            return tareaRepository.save(tarea);
        });
    }

    public boolean eliminarTarea(Long id) {
        return tareaRepository.findById(id).map(tarea -> {
            tareaRepository.delete(tarea);
            return true;
        }).orElse(false);
    }


    public List<Tarea> listaTareas() {
        // Obtener todas las tareas
        List<Tarea> tareas = tareaRepository.findAll();
        // Filtrar solo las tareas con estado activo (estado == true)
        List<Tarea> tareasActivas = tareas.stream().filter(Tarea::isEstado) // Filtrar por estado true
                .collect(Collectors.toList());
        return tareasActivas;
    }

    public long contarTareasCompletadas() {
        return tareaRepository.countByEstadoCompletado(true);
    }

    public long contarTareasNoCompletadas() {
        return tareaRepository.countByEstadoCompletado(false);
    }

    public long contarTareasEliminada() {
        return tareaRepository.countByEstado(false);
    }
}

