
---

## ✅ `README_LINUX.md`

```markdown
# ⚽ Proyecto TFG: Gol y Cambio (Linux)

Aplicación web para gestionar vídeos y eventos deportivos. Desarrollada con **Flask** y **MySQL**, y desplegada fácilmente con **Docker** en sistemas Linux.

---

## 🚀 ¿Cómo ejecutarlo en Linux?

### 1. Requisitos

Debes tener instalado:

- **Docker**
- **Docker Compose**

#### 🔧 Instalación rápida en Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker  # para aplicar los permisos del grupo docker sin reiniciar


# Clona el repositorio
git clone https://github.com/migulangel19/tfg_final.git
cd tfg_final

# Crea la carpeta de almacenamiento si no existe
mkdir -p Almacenamiento/uploads
chmod -R 777 Almacenamiento

# Levanta los contenedores
docker-compose up -d

#hay que reinicar la base de datos una vez que se levante el contenedor.

docker restart tfg_final-mysql-1

#inciar app
Listo ya tienes tu app correndo en http://127.0.0.1:5001/





