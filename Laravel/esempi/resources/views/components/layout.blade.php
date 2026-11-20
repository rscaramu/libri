@props(['title' => null])

<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">
    <title>
        {{ $title ? "{$title} - " : '' }}{{ config('app.name') }}
    </title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @stack('head')
</head>
<body>
    <header>
        <nav>
            <x-nav-link route="home">Inizio</x-nav-link>
            <x-nav-link route="books.index" match="books.*">
                Catalogo
            </x-nav-link>
        </nav>
    </header>

    <main>
        @session('status')
            <x-alert type="success">{{ $value }}</x-alert>
        @endsession

        {{ $slot }}
    </main>

    <footer>
        {{ config('app.name') }}, {{ now()->year }}
    </footer>

    @stack('scripts')
</body>
</html>
