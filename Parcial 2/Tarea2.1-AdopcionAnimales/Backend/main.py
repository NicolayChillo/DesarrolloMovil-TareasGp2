from fastapi import FastAPI
from app.database import Base, engine

from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import os
from app.core.config import UPLOAD_DIR, DATABASE_URL
from app.routes.mascota_routes import router as mascota_router
from app.routes.solicitud_routes import router as solicitud_router

# Crear tablas en PostgreSQL
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="API de Adopción de Mascotas",
    description="API para gestionar mascotas en adopción",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Crear directorio de uploads si no existe
if not os.path.exists(UPLOAD_DIR):
    os.makedirs(UPLOAD_DIR)
    print(f"📁 Directorio creado: {UPLOAD_DIR}")

# Servir archivos estáticos (imágenes)
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

app.include_router(mascota_router)
app.include_router(solicitud_router)

@app.get("/")
def root():
    return {
        "message": "API de Adopción de Mascotas funcionando",
        "database": "PostgreSQL",
        "status": "online"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}

# main.py
from app.controllers.mascota_controller import test_router

app.include_router(test_router, prefix="/test", tags=["Test"])