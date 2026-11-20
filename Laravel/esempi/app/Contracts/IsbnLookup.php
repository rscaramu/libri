<?php

namespace App\Contracts;

interface IsbnLookup
{
    /**
     * @return array{title: string, year: int}|null
     */
    public function find(string $isbn): ?array;
}
