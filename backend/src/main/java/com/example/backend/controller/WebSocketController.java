package com.example.backend.controller;


import com.example.backend.service.TareaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;

@Controller
public class WebSocketController {
    @Autowired
    private TareaService tareaService;

    @MessageMapping("/actualizarEstadisticas")
    @SendTo("/topic/estadisticas")
    public Map<String, Long> actualizarEstadisticas() {
        Map<String, Long> estadisticas = new HashMap<>();
        estadisticas.put("completadas", tareaService.contarTareasCompletadas());
        estadisticas.put("noCompletadas", tareaService.contarTareasNoCompletadas());
        estadisticas.put("eliminadas", tareaService.contarTareasEliminada());;
        return estadisticas;
    }
}
