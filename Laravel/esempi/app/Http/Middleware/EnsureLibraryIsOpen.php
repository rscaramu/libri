<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureLibraryIsOpen
{
    public function handle(Request $request, Closure $next): Response
    {
        $ora = now()->hour;

        if ($ora < 9 || $ora >= 19) {
            abort(403, 'La biblioteca apre dalle 9 alle 19.');
        }

        return $next($request);
    }
}
