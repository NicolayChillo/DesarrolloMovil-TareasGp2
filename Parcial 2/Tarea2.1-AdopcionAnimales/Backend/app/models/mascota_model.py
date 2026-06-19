from sqlalchemy import Column, Integer, String
from app.database import Base


class Mascota(Base):
    __tablename__ = "mascotas"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    especie = Column(String, nullable=False)
    raza = Column(String, nullable=True)
    sexo = Column(String, nullable=True)
    edad = Column(Integer, nullable=True)
    descripcion = Column(String, nullable=True)
    imagen_url = Column(String, nullable=True)
    estado = Column(String, default="Disponible")