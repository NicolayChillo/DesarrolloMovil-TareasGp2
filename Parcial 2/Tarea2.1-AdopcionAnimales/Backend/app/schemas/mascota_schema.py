from pydantic import BaseModel, Field
from typing import Optional
from enum import Enum

# Esquemas para la entidad Mascota
# Validar datos de entrada y salida para las operaciones relacionadas con Mascota

# Esquemas para la entidad Mascota
class MascotaBase(BaseModel):
    nombre: str = Field(min_length=2, max_length=50)
    especie: str = Field(min_length=3, max_length=30)
    raza: Optional[str] = Field(default=None, max_length=30)
    sexo: Optional[str] = Field(default=None)
    edad: int = Field(ge=0, le=30)
    descripcion: str = Field(min_length=5, max_length=200)
    imagen_url: Optional[str] = None
    estado: Optional[str] = "Disponible"

# Esquema para crear una nueva mascota
class MascotaCreate(MascotaBase):
    pass

# Esquema para la respuesta de una mascota
class MascotaResponse(MascotaBase):
    id: int
    estado: str

    class Config:
        from_attributes = True

# Esquema para actualizar una mascota
class MascotaUpdate(BaseModel):
    nombre: Optional[str] = None
    especie: Optional[str] = None
    raza: Optional[str] = None
    sexo: Optional[str] = None
    edad: Optional[int] = None
    descripcion: Optional[str] = None
    estado: Optional[EstadoMascota] = None

class EstadoMascota(str, Enum):
    disponible = "Disponible"
    adoptada = "Adoptada"
