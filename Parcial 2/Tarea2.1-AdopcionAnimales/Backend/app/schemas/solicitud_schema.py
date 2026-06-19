from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum

# Esquemas para la entidad SolicitudAdopcion
# Validar datos de entrada y salida para las operaciones relacionadas con SolicitudAdopcion

# Esquemas para la entidad SolicitudAdopcion
class SolicitudBase(BaseModel):
    mascota_id: int
    nombre_solicitante: str = Field(min_length=3, max_length=50)
    telefono: str = Field(min_length=10, max_length=15)
    comentario: Optional[str] = Field(default=None, max_length=200)

# Esquema para crear una nueva solicitud de adopción
class SolicitudCreate(SolicitudBase):
    pass

# Esquema para actualizar una solicitud de adopción
class SolicitudUpdate(BaseModel):
    mascota_id: Optional[int] = None
    nombre_solicitante: Optional[str] = None
    telefono: Optional[str] = None
    comentario: Optional[str] = None
    estado: Optional[EstadoSolicitud] = None

# Esquema para la respuesta de una solicitud de adopción
class SolicitudResponse(SolicitudBase):
    id: int
    fecha_solicitud: datetime
    estado: str

    class Config:
        from_attributes = True


class EstadoSolicitud(str, Enum):
    pendiente = "Pendiente"
    aprobada = "Aprobada"
    rechazada = "Rechazada"