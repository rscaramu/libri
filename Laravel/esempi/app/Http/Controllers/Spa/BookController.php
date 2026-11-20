<?php

namespace App\Http\Controllers\Spa;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreBookRequest;
use App\Models\Author;
use App\Models\Book;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Inertia\Inertia;
use Inertia\Response;

class BookController extends Controller
{
    public function index(Request $request): Response
    {
        return Inertia::render('Books/Index', [
            'filters' => $request->only('q'),
            'books' => Book::with('author:id,name')
                ->search($request->input('q'))
                ->orderBy('title')
                ->paginate(10)
                ->withQueryString()
                ->through(fn (Book $book) => [
                    'id' => $book->id,
                    'title' => $book->title,
                    'year' => $book->year,
                    'author' => $book->author->name,
                    'available' => $book->available,
                ]),
            'can' => [
                'create' => $request->user()
                    ?->can('create', Book::class) ?? false,
            ],
            'stats' => Inertia::defer(fn () => [
                'total' => Book::count(),
                'available' => Book::available()->count(),
            ]),
        ]);
    }

    public function create(): Response
    {
        Gate::authorize('create', Book::class);

        return Inertia::render('Books/Create', [
            'authors' => Author::orderBy('name')
                ->get(['id', 'name']),
        ]);
    }

    public function store(StoreBookRequest $request): RedirectResponse
    {
        Gate::authorize('create', Book::class);

        Book::create($request->safe()->except('categories'));

        return to_route('spa.books.index')
            ->with('status', 'Libro salvato.');
    }
}
