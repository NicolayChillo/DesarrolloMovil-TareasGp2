import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart' as gmail;
import '../models/correo_model.dart';

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}

class GmailApiService {
  gmail.GmailApi? _api;

  Future<void> initialize(Map<String, String> authHeaders) async {
    final client = GoogleHttpClient(authHeaders);
    _api = gmail.GmailApi(client);
  }

  Future<List<CorreoModel>> listMessages({int maxResults = 20}) async {
    if (_api == null) throw Exception('Gmail API no inicializado');

    final response = await _api!.users.messages.list(
      'me',
      maxResults: maxResults,
    );

    if (response.messages == null || response.messages!.isEmpty) {
      return [];
    }

    final correos = <CorreoModel>[];
    for (final msgMeta in response.messages!) {
      try {
        final fullMsg = await _api!.users.messages.get('me', msgMeta.id!, format: 'full');
        final correo = _parseGmailMessage(fullMsg);
        if (correo != null) {
          correos.add(correo);
        }
      } catch (_) {}
    }
    return correos;
  }

  Future<String?> getMessageBody(String messageId) async {
    if (_api == null) throw Exception('Gmail API no inicializado');
    final fullMsg = await _api!.users.messages.get('me', messageId, format: 'full');
    return _extractBody(fullMsg);
  }

  Future<void> sendMessage({
    required String to,
    required String subject,
    required String body,
    String? fromName,
  }) async {
    if (_api == null) throw Exception('Gmail API no inicializado');

    final message = _createMimeMessage(to, subject, body);
    final encoded = base64Url.encode(utf8.encode(message));

    await _api!.users.messages.send(
      gmail.Message(raw: encoded),
      'me',
    );
  }

  String _createMimeMessage(String to, String subject, String body) {
    final buffer = StringBuffer();
    buffer.writeln('MIME-Version: 1.0');
    buffer.writeln('Content-Type: text/plain; charset=UTF-8');
    buffer.writeln('Content-Transfer-Encoding: base64');
    buffer.writeln('To: $to');
    buffer.writeln('Subject: =?UTF-8?B?${base64Encode(utf8.encode(subject))}?=');
    buffer.writeln();
    buffer.write(body);
    return buffer.toString();
  }

  CorreoModel? _parseGmailMessage(gmail.Message message) {
    final id = message.id;
    if (id == null) return null;

    final headers = message.payload?.headers ?? [];
    String remitente = '';
    String asunto = '';
    DateTime fecha = DateTime.now();

    for (final header in headers) {
      if (header.name == 'From') remitente = header.value ?? '';
      if (header.name == 'Subject') asunto = header.value ?? '';
      if (header.name == 'Date') {
        fecha = _parseDate(header.value) ?? fecha;
      }
    }

    final cuerpo = _extractBody(message);

    bool leido = true;
    if (message.labelIds != null) {
      leido = !message.labelIds!.contains('UNREAD');
    }

    return CorreoModel(
      id: id,
      remitente: remitente,
      asunto: asunto,
      cuerpo: cuerpo,
      leido: leido,
      fecha: fecha,
    );
  }

  String _extractBody(gmail.Message message) {
    final parts = <gmail.MessagePart>[];
    _collectParts(message.payload, parts);

    for (final part in parts) {
      if (part.mimeType == 'text/plain' && part.body?.data != null) {
        try {
          return utf8.decode(base64Url.decode(_normalizeBase64(part.body!.data!)));
        } catch (_) {
          return part.body!.data!;
        }
      }
    }

    if (message.payload?.body?.data != null) {
      try {
        return utf8.decode(base64Url.decode(_normalizeBase64(message.payload!.body!.data!)));
      } catch (_) {
        return message.payload!.body!.data!;
      }
    }

    if (message.snippet != null) {
      return message.snippet!;
    }

    return '(sin contenido)';
  }

  void _collectParts(gmail.MessagePart? part, List<gmail.MessagePart> parts) {
    if (part == null) return;
    parts.add(part);
    if (part.parts != null) {
      for (final p in part.parts!) {
        _collectParts(p, parts);
      }
    }
  }

  String _normalizeBase64(String data) {
    return data.replaceAll('-', '+').replaceAll('_', '/').padRight(
      (data.length + 3) ~/ 4 * 4,
      '=',
    );
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return HttpDate.parse(dateStr);
    } catch (_) {
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }
  }
}
