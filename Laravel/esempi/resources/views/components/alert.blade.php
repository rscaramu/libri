@props(['type' => 'info', 'title' => null])

<div {{ $attributes->class(['alert', "alert-{$type}"]) }}>
    @if ($title)
        <strong>{{ $title }}</strong>
    @endif

    {{ $slot }}
</div>
