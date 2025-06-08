# ⚽ Proyecto TFG: Gol y Cambio (Windows)

Aplicación web para gestionar vídeos y eventos deportivos. Desarrollada con **Flask** y **MySQL**, y desplegada fácilmente con **Docker Desktop** en Windows.

---

## 🚀 ¿Cómo ejecutarlo en Windows?

### 1. Requisitos

- Docker Desktop instalado: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- Git instalado: [https://git-scm.com/download/win](https://git-scm.com/download/win)

---

### 2. Instrucciones para desplegar la aplicación

Abre PowerShell o CMD y ejecuta:

```bash
# Clona el repositorio
git clone https://github.com/migulangel19/tfg_final.git
cd tfg_final

# Crea la carpeta de almacenamiento si no existe
mkdir Almacenamiento

# Levanta los contenedores
docker-compose up -d

#hay que reinicar la base de datos una vez que se levante el contenedor.

docker restart tfg_final-mysql-1

#inciar app
Listo ya tienes tu app correndo en http://127.0.0.1:5001/
