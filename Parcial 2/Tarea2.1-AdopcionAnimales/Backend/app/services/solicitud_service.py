from sqlalchemy.orm import Session

from app.repositories.solicitud_repository import SolicitudRepository
from app.repositories.mascota_repository import MascotaRepository
from app.schemas.solicitud_schema import SolicitudCreate, SolicitudUpdate

class SolicitudService:

    # Métodos de servicio para SolicitudAdopcion
    # Implementación de la lógica de negocio para las operaciones relacionadas con SolicitudAdopcion

    # Metodo para obtener todas las solicitudes de adopción
    @staticmethod
    def get_all(db: Session):
        return SolicitudRepository.get_all(db)

    # Metodo para crear una solicitud de adopción
    @staticmethod
    def create(db: Session, solicitud_data: SolicitudCreate):

        mascota = MascotaRepository.get_by_id(db, solicitud_data.mascota_id)

        if not mascota:
            raise Exception("Mascota no existe")

        if mascota.estado == "Adoptada":
            raise Exception("La mascota ya fue adoptada")

        return SolicitudRepository.create(db, solicitud_data)
    
    # Metodo para actualizar una solicitud de adopción por su ID
    @staticmethod
    def update(db: Session, solicitud_id: int, solicitud_data: SolicitudUpdate):

        solicitud = SolicitudRepository.get_by_id(db, solicitud_id)

        if not solicitud:
            return None

        # Si ya fue aprobada, no se puede modificar
        if solicitud.estado == "Aprobada":
            raise Exception("No se puede modificar una solicitud ya aprobada")

        update_data = solicitud_data.model_dump(exclude_unset=True)

        # Bloquear campos críticos
        if "mascota_id" in update_data:
            raise Exception("No se puede cambiar la mascota de la solicitud")

        if "estado" in update_data:
            raise Exception("El estado no se modifica manualmente")

        # actualizar campos permitidos
        for key, value in update_data.items():
            setattr(solicitud, key, value)

        db.commit()
        db.refresh(solicitud)

        return solicitud
    
    # Metodo para eliminar una solicitud de adopción por su ID
    @staticmethod
    def delete(db: Session, solicitud_id: int):

        solicitud = SolicitudRepository.get_by_id(db, solicitud_id)

        if not solicitud:
            return None

        # No borrar si ya fue aprobada
        if solicitud.estado == "Aprobada":
            raise Exception("No se puede eliminar una solicitud aprobada")

        db.delete(solicitud)
        db.commit()

        return solicitud
    
    # Metodo para aprobar una solicitud de adopción por su ID
    @staticmethod
    def aprobar(db: Session, solicitud_id: int):

        solicitud = SolicitudRepository.get_by_id(db, solicitud_id)

        if not solicitud:
            return None

        mascota = MascotaRepository.get_by_id(db, solicitud.mascota_id)

        if mascota.estado == "Adoptada":
            raise Exception("Mascota ya está adoptada")

        solicitud.estado = "Aprobada"
        mascota.estado = "Adoptada"

        db.commit()
        db.refresh(solicitud)

        return solicitud
    
    # Metodo para rechazar una solicitud de adopción por su ID
    @staticmethod
    def rechazar(db: Session, solicitud_id: int):

        solicitud = SolicitudRepository.get_by_id(db, solicitud_id)

        if not solicitud:
            return None

        solicitud.estado = "Rechazada"

        db.commit()
        db.refresh(solicitud)

        return solicitud