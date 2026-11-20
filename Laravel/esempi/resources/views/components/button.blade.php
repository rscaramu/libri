@props(['variant' => 'primary'])

<button {{ $attributes->merge(['type' => 'button'])
    ->class(['btn', "btn-{$variant}"]) }}>
    {{ $slot }}
</button>
