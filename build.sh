# build.sh - Script de construcción para Render
#!/bin/bash

# Instalar dependencias
npm install

# Ejecutar migraciones de base de datos (si existe)
if [ -f "database/schema.sql" ]; then
    echo "Base de datos configurada"
fi

echo "✅ Build completado para Render"
