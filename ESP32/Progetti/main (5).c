// Progetto 37.4 — La struttura di un dispositivo `esp-matter`: un nodo, due endpoint, una callback per gli attributi che il controller scrive. La rete Thread e il commissioning sono gestiti dal framework.
// Listato strutturale: mostra l'organizzazione del programma. Va letto e completato
// accanto agli esempi del framework indicati nel README di questa cartella.

static esp_err_t su_attributo(callback_type_t type,
        uint16_t endpoint, uint32_t cluster, uint32_t attr,
        esp_matter_attr_val_t *val, void *priv)
{
    if (type != PRE_UPDATE) return ESP_OK;
    if (endpoint == ep_luce) {
        if (cluster == OnOff::Id &&
            attr == OnOff::Attributes::OnOff::Id)
            luce_accesa(val->val.b);
        if (cluster == LevelControl::Id &&
            attr == LevelControl::Attributes::CurrentLevel::Id)
            luce_livello(val->val.u8);        // 0..254
    }
    return ESP_OK;
}

void app_main(void)
{
    nvs_flash_init();
    node::config_t nc;
    node_t *node = node::create(&nc, su_attributo, NULL);

    dimmable_light::config_t lc;
    lc.on_off.on_off = false;
    lc.level_control.current_level = 128;
    endpoint_t *ep = dimmable_light::create(node, &lc,
                                            ENDPOINT_FLAG_NONE, NULL);
    ep_luce = endpoint::get_id(ep);

    occupancy_sensor::config_t oc;
    endpoint_t *eo = occupancy_sensor::create(node, &oc,
                                              ENDPOINT_FLAG_NONE, NULL);
    ep_pir = endpoint::get_id(eo);

    esp_matter::start(su_evento);
    avvia_pir();       // aggiorna l'attributo Occupancy dal GPIO
}
