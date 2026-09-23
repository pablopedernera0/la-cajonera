#!/bin/bash
echo "Sumando memoria (RAM) al servidor..."
curl -s -X POST http://localhost:8080/admin/sumar_ram
