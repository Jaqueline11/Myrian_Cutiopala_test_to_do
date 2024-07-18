package com.example.backend.controller;

import com.example.backend.model.Tarea;
import com.example.backend.service.TareaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@CrossOrigin(origins ="*")
@RequestMapping("/api/tareas")
public class TareaController {
    @Autowired
    private TareaService tareaService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @GetMapping
    public List<Tarea> listarTareas(){
        return tareaService.listaTareas();
    }

    @GetMapping("/todas")
    public List<Tarea> listarTodasTareas(){
        return tareaService.listaTodasTareas();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Tarea> BuscarId(@PathVariable long id){
        Optional<Tarea> tarea= tareaService.buscarTareaId(id);
        return tarea.map(
                        ResponseEntity::ok)
                .orElseGet(()-> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Tarea> createTask(@RequestBody Tarea tarea) {
        Tarea newTask = tareaService.creatTarea(tarea);
        // Emitir mensaje a través del WebSocket
        messagingTemplate.convertAndSend("/topic/estadisticas", getEstadisticas());
        return ResponseEntity.ok(newTask);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Tarea> editarTarea(@PathVariable Long id, @RequestBody Tarea DetalleTarea){
        Optional<Tarea> editarTarea= tareaService.editarTarea(id, DetalleTarea);
        if (editarTarea.isPresent()) {
            // Emitir mensaje a través del WebSocket
            messagingTemplate.convertAndSend("/topic/estadisticas", getEstadisticas());
            return ResponseEntity.ok(editarTarea.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public  ResponseEntity<Void> eliminarTarea(@PathVariable long id){
        boolean estaEliminado= tareaService.eliminarTarea(id);
        if (estaEliminado) {
            // Emitir mensaje a través del WebSocket
            messagingTemplate.convertAndSend("/topic/estadisticas", getEstadisticas());
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/estadisticas")
    public ResponseEntity<Map<String, Long>> obtenerEstadisticas() {
        return ResponseEntity.ok(getEstadisticas());
    }

    private Map<String, Long> getEstadisticas() {
        Map<String, Long> estadisticas = new HashMap<>();
        estadisticas.put("completadas", tareaService.contarTareasCompletadas());
        estadisticas.put("noCompletadas", tareaService.contarTareasNoCompletadas());
        estadisticas.put("eliminadas", tareaService.contarTareasEliminada());
        return estadisticas;
    }
}

