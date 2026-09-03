// ESP32 — La guida completa alla famiglia · capitolo 35 (Debug e collaudo)
// Listato 35.2 — Due test Unity per un filtro. Si eseguono sul chip con l'app di test di ESP-IDF, oppure su Linux.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

#include "unity.h"
#include "filtro.h"

TEST_CASE("media mobile di 4 valori", "[filtro]")
{
    filtro_t f;
    filtro_init(&f, 4);
    filtro_push(&f, 10); filtro_push(&f, 20);
    filtro_push(&f, 30); filtro_push(&f, 40);
    TEST_ASSERT_EQUAL_FLOAT(25.0f, filtro_media(&f));
}

TEST_CASE("media con buffer non pieno", "[filtro]")
{
    filtro_t f;
    filtro_init(&f, 4);
    filtro_push(&f, 10);
    TEST_ASSERT_EQUAL_FLOAT(10.0f, filtro_media(&f));
}
