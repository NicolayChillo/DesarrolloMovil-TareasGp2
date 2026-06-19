from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base


class SolicitudAdopcion(Base):
    __tablename__ = "solicitudes_adopcion"

    id = Column(Integer, primary_key=True, index=True)

    mascota_id = Column(
        Integer,
        ForeignKey("mascotas.id"),
        nullable=False
    )

    nombre_solicitante = Column(String, nullable=False)
    telefono = Column(String, nullable=False)

    fecha_solicitud = Column(
        DateTime,
        default=datetime.utcnow
    )

    estado = Column(
        String,
        default="Pendiente"
    )

    comentario = Column(String, nullable=True)

    mascota = relationship("Mascota") 