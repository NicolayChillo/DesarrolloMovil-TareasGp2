# app/routes/mascota_routes.py
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import Optional

from app.controllers import mascota_controller
from app.database import get_db

router = APIRouter(
    prefix="/mascotas",
    tags=["Mascotas"],
    responses={
        404: {"description": "Mascota no encontrada"},
        400: {"description": "Solicitud inválida"}
    }
)

# 📋 Obtener todas las mascotas
router.get(
    "/",
    response_description="Lista de mascotas"
)(
    mascota_controller.get_all_mascotas
)

# 🔍 Obtener una mascota por ID
router.get(
    "/{mascota_id}",
    response_description="Detalles de la mascota"
)(
    mascota_controller.get_mascota_by_id
)

# ➕ Crear una nueva mascota (USANDO add_api_route)
router.add_api_route(
    "/",
    mascota_controller.create_mascota,
    methods=["POST"],
    status_code=201,
    response_description="Mascota creada exitosamente"
)

# ✏️ Actualizar una mascota (USANDO add_api_route)
router.add_api_route(
    "/{mascota_id}",
    mascota_controller.update_mascota,
    methods=["PUT"],
    response_description="Mascota actualizada exitosamente"
)

# 🗑️ Eliminar una mascota
router.delete(
    "/{mascota_id}",
    response_description="Mascota eliminada exitosamente"
)(
    mascota_controller.delete_mascota
)