<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Symfony\Component\HttpFoundation\Response;

class SetLocale
{
    private const LINGUE = ['it', 'en'];

    public function handle(Request $request, Closure $next): Response
    {
        $lingua = $request->session()->get('lingua')
            ?? $request->getPreferredLanguage(self::LINGUE);

        App::setLocale($lingua);

        return $next($request);
    }
}
