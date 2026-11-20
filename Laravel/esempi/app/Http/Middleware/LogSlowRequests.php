<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class LogSlowRequests
{
    public function handle(Request $request, Closure $next): Response
    {
        return $next($request);
    }

    public function terminate(
        Request $request,
        Response $response,
    ): void {
        $inizio = $request->server('REQUEST_TIME_FLOAT');
        $ms = (microtime(true) - $inizio) * 1000;

        if ($ms > 500) {
            Log::warning('Richiesta lenta', [
                'url' => $request->fullUrl(),
                'ms' => round($ms),
            ]);
        }
    }
}
