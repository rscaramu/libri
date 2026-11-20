<?php

namespace App\Enums;

enum Role: string
{
    case Socio = 'socio';
    case Bibliotecario = 'bibliotecario';
    case Direttore = 'direttore';

    public function isStaff(): bool
    {
        return $this !== self::Socio;
    }
}
