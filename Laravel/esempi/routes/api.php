<?php

use App\Http\Controllers\Api\BookController;
use App\Http\Controllers\Api\TokenController;
use App\Http\Resources\JsonApi\BookResource as BookJsonApiResource;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::name('api.')->group(function () {
    Route::post('/tokens', [TokenController::class, 'store'])
        ->middleware('throttle:5,1')
        ->name('tokens.store');

    Route::apiResource('books', BookController::class)
        ->only(['index', 'show']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/user', fn (Request $request) => $request->user()
            ->only('id', 'name', 'email'))->name('user');

        Route::delete('/tokens', [TokenController::class, 'destroy'])
            ->name('tokens.destroy');

        Route::apiResource('books', BookController::class)
            ->only(['store', 'destroy'])
            ->middleware('ability:books:write');
    });

    Route::get('/jsonapi/books/{book}', fn (Book $book) =>
        new BookJsonApiResource($book))->name('jsonapi.book');
});
