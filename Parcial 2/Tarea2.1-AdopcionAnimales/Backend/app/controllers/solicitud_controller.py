from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.services.solicitud_service import SolicitudService
from app.schemas.solicitud_schema import (
    SolicitudCreate,
    SolicitudUpdate
)

# Controlador para la entidad SolicitudAdopcion
# Define las rutas y lógica de manejo de solicitudes para las operaciones relacionadas con SolicitudAdop

# Metodo para obtener todas las solicitudes de adopción
def get_all_solicitudes(db: Session = Depends(get_db)):
    return SolicitudService.get_all(db)

# Metodo para obtener una solicitud de adopción por su ID
def get_all_solicitudes(db: Session = Depends(get_db)):
    return SolicitudService.get_all(db)

# Metodo para crear una solicitud de adopción
def get_solicitud_by_id(solicitud_id: int, db: Session = Depends(get_db)):

    solicitud = SolicitudService.get_by_id(db, solicitud_id)

    if not solicitud:
        raise HTTPException(
            status_code=404,
            detail="Solicitud no encontrada"
        )

    return solicitud

# Metodo para actualizar una solicitud de adopción por su ID
def create_solicitud(
    solicitud_data: SolicitudCreate,
    db: Session = Depends(get_db)
):

    try:
        return SolicitudService.create(db, solicitud_data)

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )

# Metodo para actualizar una solicitud de adopción por su ID
def update_solicitud(
    solicitud_id: int,
    solicitud_data: SolicitudUpdate,
    db: Session = Depends(get_db)
):

    try:
        solicitud = SolicitudService.update(
            db,
            solicitud_id,
            solicitud_data
        )

        if not solicitud:
            raise HTTPException(
                status_code=404,
                detail="Solicitud no encontrada"
            )

        return solicitud

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )
    
# Metodo para eliminar una solicitud de adopción por su ID
def delete_solicitud(
    solicitud_id: int,
    db: Session = Depends(get_db)
):

    try:
        solicitud = SolicitudService.delete(db, solicitud_id)

        if not solicitud:
            raise HTTPException(
                status_code=404,
                detail="Solicitud no encontrada"
            )

        return {
            "message": "Solicitud eliminada correctamente"
        }

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )
    
# Metodo para aprobar una solicitud de adopción por su ID
def aprobar_solicitud(
    solicitud_id: int,
    db: Session = Depends(get_db)
):

    try:
        solicitud = SolicitudService.aprobar(db, solicitud_id)

        if not solicitud:
            raise HTTPException(
                status_code=404,
                detail="Solicitud no encontrada"
            )

        return solicitud

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )

# Metodo para rechazar una solicitud de adopción por su ID
def rechazar_solicitud(
    solicitud_id: int,
    db: Session = Depends(get_db)
):

    try:
        solicitud = SolicitudService.rechazar(db, solicitud_id)

        if not solicitud:
            raise HTTPException(
                status_code=404,
                detail="Solicitud no encontrada"
            )

        return solicitud

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )