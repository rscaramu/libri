@props([
    'name',
    'label',
    'type' => 'text',
    'value' => null,
])

<div class="campo">
    <label for="{{ $name }}">{{ $label }}</label>

    <input id="{{ $name }}" name="{{ $name }}"
           type="{{ $type }}"
           value="{{ old($name, $value) }}"
           {{ $attributes->class([
               'errore' => $errors->has($name),
           ]) }}>

    @error($name)
        <p class="messaggio-errore">{{ $message }}</p>
    @enderror
</div>
