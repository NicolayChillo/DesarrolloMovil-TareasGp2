# app/services/image_service.py
import os
import shutil
import uuid
from pathlib import Path
from fastapi import UploadFile
from app.core.config import UPLOAD_DIR, ALLOWED_EXTENSIONS, BASE_URL

class ImageService:
    @staticmethod
    def save_image(file: UploadFile) -> str:
        try:
            if not file or not file.filename:
                return None
            
            if not file.content_type.startswith('image/'):
                return None
            
            file_extension = Path(file.filename).suffix.lower()
            if file_extension not in ALLOWED_EXTENSIONS:
                return None
            
            os.makedirs(UPLOAD_DIR, exist_ok=True)
            
            unique_filename = f"{uuid.uuid4()}{file_extension}"
            file_path = os.path.join(UPLOAD_DIR, unique_filename)
            
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(file.file, buffer)
            
            file.file.seek(0)
            
            # ✅ Generar URL completa para la app móvil
            image_url = f"{BASE_URL}/{UPLOAD_DIR}/{unique_filename}".replace("\\", "/")
            
            print(f"✅ Imagen guardada: {image_url}")
            return image_url
            
        except Exception as e:
            print(f"❌ Error al guardar imagen: {e}")
            return None