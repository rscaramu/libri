@props(['route', 'match' => null])

<a href="{{ route($route) }}"
   @class(['attivo' => request()->routeIs($match ?? $route)])>
    {{ $slot }}
</a>
