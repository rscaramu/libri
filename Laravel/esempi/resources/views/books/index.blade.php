<x-layout title="Catalogo">
    <h1>Catalogo</h1>

    @forelse ($books as $book)
        <x-card>
            <x-slot:header>{{ $book->title }}</x-slot:header>
            {{ $book->author->name }}, {{ $book->year }}
        </x-card>
    @empty
        <x-alert>Nessun libro in catalogo.</x-alert>
    @endforelse
</x-layout>
