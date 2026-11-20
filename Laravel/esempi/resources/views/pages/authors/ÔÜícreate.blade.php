<?php

use App\Models\Author;
use Livewire\Attributes\Title;
use Livewire\Attributes\Validate;
use Livewire\Component;

new #[Title('Nuovo autore')] class extends Component
{
    #[Validate('required|string|max:120')]
    public string $name = '';

    #[Validate('nullable|alpha|size:2')]
    public ?string $country = null;

    #[Validate('nullable|integer|max:2026')]
    public ?int $birth_year = null;

    public function save()
    {
        $this->authorize('create', Author::class);

        $author = Author::create($this->validate());

        session()->flash('status', 'Autore salvato.');

        $this->dispatch('author-created', id: $author->id);

        return $this->redirectRoute('books.index', navigate: true);
    }
};
?>

<form wire:submit="save">
    <label for="name">Nome</label>
    <input id="name" type="text" wire:model.blur="name">
    @error('name') <p class="errore">{{ $message }}</p> @enderror

    <label for="country">Paese (sigla)</label>
    <input id="country" type="text" wire:model="country">
    @error('country') <p class="errore">{{ $message }}</p> @enderror

    <label for="birth_year">Anno di nascita</label>
    <input id="birth_year" type="number" wire:model="birth_year">
    @error('birth_year')
        <p class="errore">{{ $message }}</p>
    @enderror

    <button type="submit" wire:loading.attr="disabled">
        Salva
    </button>
</form>
