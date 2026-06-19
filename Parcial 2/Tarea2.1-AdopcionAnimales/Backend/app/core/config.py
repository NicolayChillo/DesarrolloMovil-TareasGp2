import os
from dotenv import load_dotenv

load_dotenv()

# Configuración de PostgreSQL
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

# URL de conexión a PostgreSQL
DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Configuración de imágenes
UPLOAD_DIR = os.getenv("UPLOAD_DIR", "uploads/mascotas")
MAX_FILE_SIZE = int(os.getenv("MAX_FILE_SIZE", 5242880))  # 5MB por defecto
BASE_URL = os.getenv("BASE_URL", "http://localhost:8000")

# Extensiones permitidas para imágenes
ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"}