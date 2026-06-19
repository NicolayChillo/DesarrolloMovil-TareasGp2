# app/controllers/mascota_controller.py
from fastapi import Form, File, UploadFile, Depends, HTTPException, Query, APIRouter

from sqlalchemy.orm import Session
from typing import Optional

from app.database import get_db
from app.models.mascota_model import Mascota 
from app.services.mascota_service import MascotaService
from app.schemas.mascota_schema import MascotaCreate, MascotaUpdate

# ============================================================
# Controladores para la entidad Mascota
# ============================================================

# 📋 Obtener todas las mascotas
def get_all_mascotas(
    db: Session = Depends(get_db),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    estado: Optional[str] = Query(None)
):
    return MascotaService.get_all_mascotas(db, skip=skip, limit=limit, estado=estado)

# 🔍 Obtener una mascota por ID
def get_mascota_by_id(
    mascota_id: int,
    db: Session = Depends(get_db)
):
    mascota = MascotaService.get_mascota_by_id(db, mascota_id)
    if not mascota:
        raise HTTPException(status_code=404, detail="Mascota no encontrada")
    return mascota

# ➕ Crear una nueva mascota
def create_mascota(
    nombre: str = Form(...),
    especie: str = Form(...),
    raza: Optional[str] = Form(None),
    sexo: Optional[str] = Form(None),
    edad: int = Form(...),
    descripcion: str = Form(...),
    file: UploadFile = File(None),
    db: Session = Depends(get_db)
):
    print("=" * 60)
    print("🔍 DEBUG INFO (CREATE):")
    print(f"File object: {file}")
    if file:
        print(f"✅ File name: {file.filename}")
        print(f"✅ File content_type: {file.content_type}")
    else:
        print("❌ File es None")
    print("=" * 60)
    
    mascota_data = MascotaCreate(
        nombre=nombre,
        especie=especie,
        raza=raza,
        sexo=sexo,
        edad=edad,
        descripcion=descripcion
    )
    
    return MascotaService.create_mascota(db, mascota_data, file)

# ✏️ Actualizar una mascota
def update_mascota(
    mascota_id: int,
    nombre: Optional[str] = Form(None),
    especie: Optional[str] = Form(None),
    raza: Optional[str] = Form(None),
    sexo: Optional[str] = Form(None),
    edad: Optional[int] = Form(None),
    descripcion: Optional[str] = Form(None),
    estado: Optional[str] = Form(None),
    file: UploadFile = File(None),
    db: Session = Depends(get_db)
):
    print("=" * 60)
    print("🔍 DEBUG INFO (UPDATE):")
    print(f"File object: {file}")
    if file:
        print(f"✅ File name: {file.filename}")
    else:
        print("❌ No se recibió archivo nuevo")
    print("=" * 60)
    
    # Construir dict con datos a actualizar
    update_data = {}
    if nombre is not None:
        update_data["nombre"] = nombre
    if especie is not None:
        update_data["especie"] = especie
    if raza is not None:
        update_data["raza"] = raza
    if sexo is not None:
        update_data["sexo"] = sexo
    if edad is not None:
        update_data["edad"] = edad
    if descripcion is not None:
        update_data["descripcion"] = descripcion
    if estado is not None:
        update_data["estado"] = estado
    
    if not update_data and not file:
        raise HTTPException(
            status_code=400,
            detail="No se proporcionaron datos para actualizar"
        )
    
    mascota_update = MascotaUpdate(**update_data)
    
    return MascotaService.update_mascota(db, mascota_id, mascota_update, file)

# 🗑️ Eliminar una mascota
# app/controllers/mascota_controller.py
def delete_mascota(
    mascota_id: int,
    db: Session = Depends(get_db)
):
    try:
        print("=" * 60)
        print(f"🗑️ DELETE MASCOTA ID: {mascota_id}")
        print("=" * 60)
        
        # Verificar que la mascota existe
        mascota = db.query(Mascota).filter(Mascota.id == mascota_id).first()
        print(f"📦 Mascota encontrada: {mascota}")
        
        if not mascota:
            print("❌ Mascota no encontrada")
            raise HTTPException(status_code=404, detail="Mascota no encontrada")
        
        # Eliminar imagen si existe
        if mascota.imagen_url:
            print(f"🗑️ Eliminando imagen: {mascota.imagen_url}")
            # Aquí va el código para eliminar la imagen
            # ImageService.delete_image(mascota.imagen_url)
        
        # Eliminar la mascota
        db.delete(mascota)
        db.commit()
        print("✅ Mascota eliminada exitosamente")
        
        return {"message": "Mascota eliminada correctamente"}
        
    except HTTPException:
        raise
    except Exception as e:
        print(f"❌ Error en delete_mascota: {e}")
        import traceback
        traceback.print_exc()
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error al eliminar mascota: {str(e)}")



#####
# app/controllers/mascota_controller.py

# Crear un router de prueba
test_router = APIRouter()

@test_router.post("/test-upload")
async def test_upload(
    nombre: str = Form(...),
    file: UploadFile = File(...)
):
    print("=" * 60)
    print("🔍 TEST UPLOAD:")
    print(f"nombre: {nombre}")
    print(f"file: {file}")
    print(f"file.filename: {file.filename if file else 'None'}")
    print("=" * 60)
    
    return {
        "nombre": nombre,
        "filename": file.filename if file else "None",
        "content_type": file.content_type if file else "None"
    }