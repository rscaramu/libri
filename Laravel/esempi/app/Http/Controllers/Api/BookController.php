<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreBookRequest;
use App\Http\Resources\BookResource;
use App\Models\Book;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class BookController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $books = Book::with('author')
            ->search($request->input('q'))
            ->orderBy('title')
            ->paginate(4);

        return BookResource::collection($books);
    }

    public function show(Book $book): BookResource
    {
        return new BookResource(
            $book->load(['author', 'categories'])
        );
    }

    public function store(StoreBookRequest $request): JsonResponse
    {
        Gate::authorize('create', Book::class);

        $book = Book::create(
            $request->safe()->except('categories')
        );

        return (new BookResource($book->refresh()))
            ->response()
            ->setStatusCode(201);
    }

    public function destroy(Book $book): Response
    {
        Gate::authorize('delete', $book);

        $book->delete();

        return response()->noContent();
    }
}
