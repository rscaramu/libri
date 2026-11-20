<?php

namespace App\Services;

use App\Contracts\IsbnLookup;

class FakeLookup implements IsbnLookup
{
    public function find(string $isbn): ?array
    {
        return ['title' => "Libro {$isbn}", 'year' => 2000];
    }
}
