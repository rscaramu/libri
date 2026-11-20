<?php

namespace App\Exceptions;

use App\Models\Book;
use Exception;
use Illuminate\Http\RedirectResponse;

class BookNotAvailable extends Exception
{
    public function __construct(public Book $book)
    {
        parent::__construct(
            "Il libro {$book->title} non è disponibile."
        );
    }

    public function render(): RedirectResponse
    {
        return to_route('books.show', $this->book)
            ->with('status', $this->getMessage());
    }

    public function report(): bool
    {
        return false;
    }
}
