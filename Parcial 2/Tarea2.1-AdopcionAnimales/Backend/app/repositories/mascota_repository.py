from sqlalchemy.orm import Session
from app.models.mascota_model import Mascota
from app.schemas.mascota_schema import MascotaCreate


class MascotaRepository:

    # Métodos CRUD para Mascota
    # Implementación de métodos para interactuar con la base de datos

    # Metodo para obtener todas las mascotas
    @staticmethod
    def get_all(
        db: Session, 
        skip: int = 0, 
        limit: int = 100, 
        estado: Optional[str] = None
    ):
        query = db.query(Mascota)
        if estado:
            query = query.filter(Mascota.estado == estado)
        return query.offset(skip).limit(limit).all()

    # Metodo para obtener una mascota por su ID
    @staticmethod
    def get_by_id(db: Session, mascota_id: int):
        return db.query(Mascota).filter(Mascota.id == mascota_id).first()

    # Metodo para crear una nueva mascota
    @staticmethod
    def create(db: Session, mascota_data):
        # Convertir el objeto Pydantic a diccionario
        mascota_dict = mascota_data.model_dump()
        print(f"📦 Datos a guardar: {mascota_dict}")
        
        nueva_mascota = Mascota(**mascota_dict)
        db.add(nueva_mascota)
        db.commit()
        db.refresh(nueva_mascota)
        return nueva_mascota
    
    # Metodo para actualizar una mascota por su ID
    @staticmethod
    def update(db: Session, mascota_id: int, mascota_data):
        mascota = db.query(Mascota).filter(
            Mascota.id == mascota_id
        ).first()

        if not mascota:
            return None

        update_data = mascota_data.model_dump(
            exclude_unset=True
        )

        for key, value in update_data.items():
            setattr(mascota, key, value)

        try:
            db.commit()
            db.refresh(mascota)
            return mascota
        except Exception:
            db.rollback()
            raise

    # Metodo para eliminar una mascota por su ID
    @staticmethod
    def delete(db: Session, mascota_id: int):
        try:
            print(f"🗑️ Repository - Eliminando mascota ID: {mascota_id}")
            
            mascota = db.query(Mascota).filter(Mascota.id == mascota_id).first()
            
            if not mascota:
                print("❌ Mascota no encontrada en repository")
                return None
            
            print(f"📦 Mascota encontrada: {mascota.nombre} (ID: {mascota.id})")
            
            db.delete(mascota)
            db.commit()
            print("✅ Mascota eliminada en repository")
            
            return mascota
            
        except Exception as e:
            print(f"❌ Error en repository delete: {e}")
            db.rollback()
            raise