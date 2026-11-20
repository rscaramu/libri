<?php

namespace App\Observers;

use App\Models\Book;
use Illuminate\Support\Facades\Log;

class BookObserver
{
    public function creating(Book $book): void
    {
        $book->isbn = $book->isbn
            ? preg_replace('/[^0-9]/', '', $book->isbn)
            : null;
    }

    public function updated(Book $book): void
    {
        if ($book->wasChanged('price')) {
            Log::info('Prezzo modificato', [
                'libro' => $book->id,
                'da' => $book->getOriginal('price'),
                'a' => $book->price,
            ]);
        }
    }

    public function deleting(Book $book): bool
    {
        return ! $book->loans()->open()->exists();
    }
}
