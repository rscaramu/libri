<?php

namespace App\Http\Controllers;

use App\Models\Book;
use App\Http\Requests\StoreBookRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class BookController extends Controller
{
    public function index(): View
    {
        return view('books.index', [
            'books' => Book::with('author')
                ->orderBy('title')
                ->get(),
        ]);
    }

    public function store(StoreBookRequest $request): RedirectResponse
    {
        \Illuminate\Support\Facades\Gate::authorize('create', Book::class);
        $book = Book::create($request->safe()->except('categories'));
        $book->categories()->sync($request->validated('categories', []));

        return to_route('books.show', $book)
            ->with('status', 'Libro salvato.');
    }

    public function store2(Request $request): RedirectResponse
    {
    $validated = $request->validate([
        'title' => ['required', 'string', 'max:255'],
        'author_id' => ['required', 'exists:authors,id'],
        'year' => ['required', 'integer', 'between:1450,2100'],
        'pages' => ['nullable', 'integer', 'min:1'],
        'price' => ['required', 'numeric', 'min:0'],
        'isbn' => ['nullable', 'digits:13', 'unique:books,isbn'],
    ]);
        return back();
    }

    public function show(Book $book): View
    {
        return view('books.show', ['book' => $book]);
    }

    public function destroy(Book $book): RedirectResponse
    {
        \Illuminate\Support\Facades\Gate::authorize('delete', $book);

        $book->delete();

        return to_route('books.index')
            ->with('status', 'Libro eliminato.');
    }
}
