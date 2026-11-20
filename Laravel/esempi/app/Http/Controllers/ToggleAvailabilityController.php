<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\RedirectResponse;

class ToggleAvailabilityController extends Controller
{
    public function __invoke(Book $book): RedirectResponse
    {
        $book->update(['available' => ! $book->available]);

        return back();
    }
}
