<?php

namespace App\Services;

class IsbnChecker
{
    public function isValid(string $code): bool
    {
        if (! preg_match('/^[0-9]{13}$/', $code)) {
            return false;
        }

        $sum = 0;

        foreach (str_split($code) as $i => $digit) {
            $sum += (int) $digit * ($i % 2 === 0 ? 1 : 3);
        }

        return $sum % 10 === 0;
    }
}
