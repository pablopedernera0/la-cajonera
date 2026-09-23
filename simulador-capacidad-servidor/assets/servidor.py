#!/usr/bin/env python3
"""Servidor simulado para la práctica de capacidad. Sin dependencias externas."""
import json
import threading
import time
from http.server import BaseHTTPRequestHandler, HTTPServer
from socketserver import ThreadingMixIn

PUERTO = 8080

# Cuántas peticiones acumuladas tolera CADA unidad de "workers" antes de que
# empiece a formarse cola (y por lo tanto suba la latencia).
UMBRAL_LATENCIA_POR_WORKER = 500

# Cuántas peticiones acumuladas tolera CADA GB de RAM antes de quedarse sin
# memoria y empezar a rechazar conexiones.
UMBRAL_FALLA_POR_GB = 1200

estado = {"workers": 1, "ram_gb": 1, "total": 0, "fallidas": 0}
lock = threading.Lock()


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass  # silenciar el log de acceso, ensucia la terminal del alumno

    def _responder(self, code, cuerpo, content_type="text/plain; charset=utf-8"):
        data = cuerpo.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path == "/carga":
            self._carga()
        elif self.path == "/status":
            self._status()
        else:
            self._responder(404, "no encontrado")

    def do_POST(self):
        if self.path == "/admin/sumar_cpu":
            with lock:
                estado["workers"] += 9
                w = estado["workers"]
            self._responder(200, f"Workers: ahora hay {w}.\n")
        elif self.path == "/admin/sumar_ram":
            with lock:
                estado["ram_gb"] += 9
                r = estado["ram_gb"]
            self._responder(200, f"RAM: ahora hay {r}GB.\n")
        else:
            self._responder(404, "no encontrado")

    def _carga(self):
        with lock:
            estado["total"] += 1
            total = estado["total"]
            workers = estado["workers"]
            ram_gb = estado["ram_gb"]

        umbral_falla = ram_gb * UMBRAL_FALLA_POR_GB
        if total > umbral_falla:
            with lock:
                estado["fallidas"] += 1
            self._responder(503, "memoria insuficiente\n")
            return

        umbral_latencia = workers * UMBRAL_LATENCIA_POR_WORKER
        if total > umbral_latencia:
            exceso = total - umbral_latencia
            delay = min(exceso / 250.0, 2.0)
            time.sleep(delay)

        self._responder(200, "ok\n")

    def _status(self):
        with lock:
            e = dict(estado)
        html = f"""<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta http-equiv="refresh" content="5">
<title>Estado del servidor simulado</title>
<style>
  body {{ font-family: monospace; background:#0d1117; color:#c9d1d9; padding:2rem; }}
  h1 {{ color:#58a6ff; }}
  table {{ border-collapse: collapse; margin-top: 1rem; }}
  td {{ padding: 0.4rem 1.2rem; border-bottom: 1px solid #30363d; }}
  td.label {{ color:#8b949e; }}
  td.value {{ color:#3fb950; font-weight:bold; }}
</style>
</head>
<body>
<h1>Servidor simulado — estado actual</h1>
<table>
<tr><td class="label">Workers (procesos)</td><td class="value">{e['workers']}</td></tr>
<tr><td class="label">RAM</td><td class="value">{e['ram_gb']} GB</td></tr>
<tr><td class="label">Peticiones procesadas</td><td class="value">{e['total']}</td></tr>
<tr><td class="label">Peticiones fallidas</td><td class="value">{e['fallidas']}</td></tr>
</table>
<p style="color:#8b949e; margin-top:1.5rem;">Esta página se actualiza sola cada 5 segundos.</p>
</body>
</html>
"""
        self._responder(200, html, content_type="text/html; charset=utf-8")


class ServidorHilos(ThreadingMixIn, HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


if __name__ == "__main__":
    servidor = ServidorHilos(("0.0.0.0", PUERTO), Handler)
    print(f"Servidor simulado escuchando en el puerto {PUERTO}")
    servidor.serve_forever()
