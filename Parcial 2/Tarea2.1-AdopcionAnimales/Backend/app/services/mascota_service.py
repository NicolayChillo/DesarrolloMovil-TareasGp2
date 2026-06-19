# app/services/mascota_service.py
from sqlalchemy.orm import Session
from fastapi import HTTPException

from app.repositories.mascota_repository import MascotaRepository
from app.schemas.mascota_schema import MascotaCreate, MascotaUpdate
from app.services.image_service import ImageService

class MascotaService:

    # Métodos de servicio para Mascota

    # Metodo para obtener todas las mascotas
    @staticmethod
    def get_all_mascotas(
        db: Session, 
        skip: int = 0, 
        limit: int = 100, 
        estado: Optional[str] = None
    ):
        return MascotaRepository.get_all(db)

    # Metodo para obtener una mascota por su ID
    @staticmethod
    def get_mascota_by_id(db: Session, mascota_id: int):
        mascota = MascotaRepository.get_by_id(db, mascota_id)
        if not mascota:
            raise HTTPException(status_code=404, detail="Mascota no encontrada")
        return mascota

    # Metodo para crear una nueva mascota
    @staticmethod
    def create_mascota(db: Session, mascota_data: MascotaCreate, file=None):
        mascota_dict = mascota_data.model_dump()

        # Guardar imagen localmente
        if file and file.filename:
            try:
                print("📸 Guardando imagen localmente...")
                image_url = ImageService.save_image(file)
                if image_url:
                    mascota_dict["imagen_url"] = image_url
                    print(f"✅ IMAGE URL: {image_url}")
                else:
                    print("❌ No se pudo guardar la imagen")
                    mascota_dict["imagen_url"] = None
            except Exception as e:
                print(f"❌ ERROR AL GUARDAR IMAGEN: {e}")
                mascota_dict["imagen_url"] = None
        else:
            mascota_dict["imagen_url"] = None
            print("❌ NO IMAGE UPLOADED")

        mascota_data_actualizado = MascotaCreate(**mascota_dict)
        return MascotaRepository.create(db, mascota_data_actualizado)

    # ✅ Metodo para actualizar una mascota por su ID (ACTUALIZADO)
    @staticmethod
    def update_mascota(
        db: Session,
        mascota_id: int,
        mascota_data: MascotaUpdate,
        file=None  # ← Agregamos file como parámetro
    ):
        # Obtener la mascota existente
        mascota_existente = MascotaRepository.get_by_id(db, mascota_id)
        if not mascota_existente:
            raise HTTPException(status_code=404, detail="Mascota no encontrada")
        
        # Verificar estado
        if mascota_data.estado == "Adoptada":
            raise HTTPException(status_code=400, detail="La mascota ya fue adoptada")
        
        # Si hay un archivo nuevo, actualizar la imagen
        if file and file.filename:
            try:
                print("📸 Actualizando imagen...")
                # Eliminar imagen anterior si existe
                if mascota_existente.imagen_url:
                    ImageService.delete_image(mascota_existente.imagen_url)
                    print(f"🗑️ Imagen anterior eliminada: {mascota_existente.imagen_url}")
                
                # Guardar nueva imagen
                image_url = ImageService.save_image(file)
                if image_url:
                    # Actualizar el campo imagen_url en los datos
                    mascota_data.imagen_url = image_url
                    print(f"✅ Nueva imagen guardada: {image_url}")
                else:
                    print("❌ No se pudo guardar la nueva imagen")
                    mascota_data.imagen_url = None
            except Exception as e:
                print(f"❌ ERROR AL ACTUALIZAR IMAGEN: {e}")
                raise HTTPException(status_code=500, detail=f"Error al actualizar imagen: {str(e)}")
        
        return MascotaRepository.update(db, mascota_id, mascota_data)

    # Metodo para eliminar una mascota por su ID
    @staticmethod
    def delete_mascota(db: Session, mascota_id: int):
        try:
            print(f"🗑️ Service - Eliminando mascota ID: {mascota_id}")
            
            mascota = MascotaRepository.delete(db, mascota_id)
            
            if not mascota:
                print("❌ Mascota no encontrada en repository")
                raise HTTPException(status_code=404, detail="Mascota no encontrada")
            
            print("✅ Mascota eliminada en service")
            return mascota
            
        except HTTPException:
            raise
        except Exception as e:
            print(f"❌ Error en delete_mascota service: {e}")
            import traceback
            traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))