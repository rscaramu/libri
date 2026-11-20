<x-layout title="Accesso">
    <form method="POST" action="{{ route('login.store') }}">
        @csrf

        <x-forms.input name="email" label="Posta elettronica"
                       type="email" required autofocus />
        <x-forms.input name="password" label="Password"
                       type="password" required />

        <label>
            <input type="checkbox" name="remember" value="1">
            Ricordami su questo dispositivo
        </label>

        <x-button type="submit">Accedi</x-button>
    </form>
</x-layout>
