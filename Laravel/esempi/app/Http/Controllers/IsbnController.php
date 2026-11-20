<?php

namespace App\Http\Controllers;

use App\Services\IsbnChecker;
use Illuminate\Http\Request;

class IsbnController extends Controller
{
    public function __construct(
        private IsbnChecker $checker,
    ) {}

    public function check(Request $request, string $code): array
    {
        return [
            'codice' => $code,
            'valido' => $this->checker->isValid($code),
            'richiesto_da' => $request->ip(),
        ];
    }
}
