const { onValueCreated } = require("firebase-functions/v2/database");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

// =====================================================
// Notificación al crear un nuevo mensaje
// =====================================================

exports.sendChatNotification = onValueCreated(
    "/chats/{chatId}/{mensajeId}",
    async (event) => {

        // Verificar que exista el dato
        if (!event.data) {
            console.log("No existe información del mensaje.");
            return;
        }

        const mensaje = event.data.val();
        const autor = mensaje.autor;

        // Buscar el usuario receptor
        const usuariosSnapshot = await admin
            .database()
            .ref("usuarios")
            .once("value");

        let token = null;
        let receptorEmail = "";

        if (usuariosSnapshot.exists()) {

            const usuarios = usuariosSnapshot.val();

            for (const uid in usuarios) {

                const user = usuarios[uid];

                if (
                    user.email &&
                    user.email !== autor &&
                    user.fcmToken
                ) {
                    receptorEmail = user.email;
                    token = user.fcmToken;
                    break;
                }
            }
        }

        if (!token) {
            console.log("No se encontró token del receptor.");
            return;
        }

        console.log(`Enviando notificación a ${receptorEmail}`);

        const message = {
            token: token,

            notification: {
                title: `Mensaje de ${autor}`,
                body: mensaje.texto,
            },

            data: {
                chatId: event.params.chatId,
                autor: autor,
                receptor: receptorEmail,
            },

            android: {
                notification: {
                    sound: "default",
                },
            },
        };

        try {

            const response = await admin
                .messaging()
                .send(message);

            console.log("Notificación enviada correctamente.");
            console.log(response);

        } catch (error) {

            console.error("Error enviando notificación:");
            console.error(error);

        }

        return;
    }
);

// =====================================================
// Función de prueba
// =====================================================

exports.testNotification = onCall(async (request) => {

    const { token, message } = request.data;

    if (!token) {

        throw new HttpsError(
            "invalid-argument",
            "Token requerido."
        );

    }

    const notification = {

        token: token,

        notification: {
            title: "Prueba desde Cloud Function",
            body: message || "Hola, esto es una prueba.",
        },

        android: {
            notification: {
                sound: "default",
            },
        },
    };

    try {

        const response = await admin
            .messaging()
            .send(notification);

        return {
            success: true,
            response,
        };

    } catch (error) {

        throw new HttpsError(
            "internal",
            error.message
        );

    }

});