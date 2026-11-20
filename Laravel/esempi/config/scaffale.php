<?php

return [
    'per_pagina' => 20,
    'giorni_prestito' => (int) env('SCAFFALE_GIORNI', 30),
    'max_prestiti' => 5,
    'max_rinnovi' => (int) env('SCAFFALE_MAX_RINNOVI', 2),
];
