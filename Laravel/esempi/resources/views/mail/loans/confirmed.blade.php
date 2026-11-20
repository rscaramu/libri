<x-mail::message>
# Prestito registrato

Gentile {{ $loan->user->name }},

abbiamo registrato il prestito del libro
**{{ $loan->book->title }}**.

<x-mail::panel>
Data di restituzione: {{ $loan->due_at->format('d/m/Y') }}
</x-mail::panel>

<x-mail::button :url="$url">
Scheda del libro
</x-mail::button>

Buona lettura,<br>
{{ config('app.name') }}
</x-mail::message>
