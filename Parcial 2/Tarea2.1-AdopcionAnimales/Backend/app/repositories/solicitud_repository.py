from sqlalchemy.orm import Session
from app.models.solicitud_model import SolicitudAdopcion
from app.schemas.solicitud_schema import SolicitudCreate, SolicitudUpdate


class SolicitudRepository:

    # Métodos CRUD para SolicitudAdopcion
    # Implementación de métodos para interactuar con la base de datos

    # Metodo para obtener todas las solicitudes de adopción
    @staticmethod
    def get_all(db: Session):
        return db.query(SolicitudAdopcion).all()

    # Metodo para obtener una solicitud de adopción por su ID
    @staticmethod
    def get_by_id(db: Session, solicitud_id: int):
        return db.query(SolicitudAdopcion).filter(
            SolicitudAdopcion.id == solicitud_id
        ).first()

    # Metodo para obtener todas las solicitudes de adopción asociadas a una mascota específica
    @staticmethod
    def get_by_mascota(db: Session, mascota_id: int):
        return db.query(SolicitudAdopcion).filter(
            SolicitudAdopcion.mascota_id == mascota_id
        ).all()

    # Metodo para obtener todas las solicitudes de adopción asociadas a un usuario específico
    @staticmethod
    def create(db: Session, solicitud_data: SolicitudCreate):
        nueva = SolicitudAdopcion(**solicitud_data.model_dump())
        db.add(nueva)
        db.commit()
        db.refresh(nueva)
        return nueva

    # Metodo para actualizar una solicitud de adopción por su ID
    @staticmethod
    def update(db: Session, solicitud_id: int, solicitud_data: SolicitudUpdate):
        solicitud = db.query(SolicitudAdopcion).filter(
            SolicitudAdopcion.id == solicitud_id
        ).first()

        if not solicitud:
            return None

        update_data = solicitud_data.model_dump(exclude_unset=True)

        for key, value in update_data.items():
            setattr(solicitud, key, value)

        db.commit()
        db.refresh(solicitud)
        return solicitud

    # Metodo para eliminar una solicitud de adopción por su ID
    @staticmethod
    def delete(db: Session, solicitud_id: int):
        solicitud = db.query(SolicitudAdopcion).filter(
            SolicitudAdopcion.id == solicitud_id
        ).first()

        if not solicitud:
            return None

        db.delete(solicitud)
        db.commit()
        return solicitud