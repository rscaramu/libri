@props(['color' => 'grigio'])

<span {{ $attributes->class(['badge', "badge-{$color}"]) }}>
    {{ $slot }}
</span>
