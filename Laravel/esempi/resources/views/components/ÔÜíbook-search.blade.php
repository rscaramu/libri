<?php

use App\Models\Book;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Url;
use Livewire\Component;
use Livewire\WithPagination;

new class extends Component
{
    use WithPagination;

    #[Url(as: 'q')]
    public string $search = '';

    public bool $onlyAvailable = false;

    public function updated(): void
    {
        $this->resetPage();
    }

    #[Computed]
    public function books()
    {
        return Book::with('author')
            ->search($this->search)
            ->when($this->onlyAvailable, fn ($q) => $q->available())
            ->orderBy('title')
            ->paginate(4);
    }

    public function toggle(int $id): void
    {
        $book = Book::findOrFail($id);

        $this->authorize('update', $book);

        $book->update(['available' => ! $book->available]);
    }
};
?>

<div>
    <input type="search" wire:model.live.debounce.300ms="search"
           placeholder="Cerca per titolo o ISBN">

    <label>
        <input type="checkbox" wire:model.live="onlyAvailable">
        Solo disponibili
    </label>

    <p wire:loading>Ricerca in corso...</p>

    <ul>
        @forelse ($this->books as $book)
            <li wire:key="book-{{ $book->id }}">
                {{ $book->title }} ({{ $book->author->name }})

                @can('update', $book)
                    <button wire:click="toggle({{ $book->id }})">
                        {{ $book->available ? 'Ritira' : 'Rendi' }}
                    </button>
                @endcan
            </li>
        @empty
            <li>Nessun libro trovato.</li>
        @endforelse
    </ul>

    {{ $this->books->links() }}
</div>
