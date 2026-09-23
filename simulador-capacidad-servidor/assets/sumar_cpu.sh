#!/bin/bash
echo "Sumando procesos (workers) al servidor..."
curl -s -X POST http://localhost:8080/admin/sumar_cpu
