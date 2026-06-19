from fastapi import APIRouter

from app.controllers import solicitud_controller

router = APIRouter(
    prefix="/solicitudes",
    tags=["Solicitudes"]
)

# Rutas para la entidad SolicitudAdopcion
# Define las rutas y lógica de manejo de solicitudes para las operaciones relacionadas con SolicitudAdopcion

# Ruta para obtener todas las solicitudes de adopción
router.get("/")(
    solicitud_controller.get_all_solicitudes
)

# Ruta para obtener una solicitud de adopción por su ID
router.get("/{solicitud_id}")(
    solicitud_controller.get_solicitud_by_id
)

# Ruta para crear una nueva solicitud de adopción
router.post("/")(
    solicitud_controller.create_solicitud
)

# Ruta para actualizar una solicitud de adopción por su ID
router.put("/{solicitud_id}")(
    solicitud_controller.update_solicitud
)

# Ruta para eliminar una solicitud de adopción por su ID
router.delete("/{solicitud_id}")(
    solicitud_controller.delete_solicitud
)

# Ruta para aprobar una solicitud de adopción por su ID
router.patch("/{solicitud_id}/aprobar")(
    solicitud_controller.aprobar_solicitud
)

# Ruta para rechazar una solicitud de adopción por su ID
router.patch("/{solicitud_id}/rechazar")(
    solicitud_controller.rechazar_solicitud
)