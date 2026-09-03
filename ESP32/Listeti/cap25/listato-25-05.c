// ESP32 — La guida completa alla famiglia · capitolo 25 (Rete e protocolli)
// Listato 25.5 — Streaming MJPEG dalla camera. Il ciclo esce quando il browser chiude la pagina; ogni client occupa un task del server, che per default ne ha pochi.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

static esp_err_t stream_handler(httpd_req_t *req) {
    httpd_resp_set_type(req,
        "multipart/x-mixed-replace;boundary=frame");
    char hdr[64];
    while (1) {
        camera_fb_t *fb = esp_camera_fb_get();
        if (!fb) break;
        int n = snprintf(hdr, sizeof hdr,
            "\r\n--frame\r\nContent-Type: image/jpeg\r\n"
            "Content-Length: %u\r\n\r\n", fb->len);
        esp_err_t r = httpd_resp_send_chunk(req, hdr, n);
        if (r == ESP_OK)
            r = httpd_resp_send_chunk(req, (char *)fb->buf, fb->len);
        esp_camera_fb_return(fb);
        if (r != ESP_OK) break;       // il client ha chiuso
    }
    return ESP_OK;
}

httpd_uri_t uri = { .uri = "/stream", .method = HTTP_GET,
                    .handler = stream_handler };
httpd_register_uri_handler(server, &uri);
