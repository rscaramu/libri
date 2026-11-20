<?php

namespace App\Rules;

use App\Services\IsbnChecker;
use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class ValidIsbn implements ValidationRule
{
    public function validate(
        string $attribute,
        mixed $value,
        Closure $fail,
    ): void {
        if (! (new IsbnChecker)->isValid((string) $value)) {
            $fail('Il codice ISBN non è valido.');
        }
    }
}
