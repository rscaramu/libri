<?php

use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\BookController;
use App\Http\Controllers\PageController;
use App\Http\Controllers\ReturnLoanController;
use Illuminate\Support\Facades\Route;

Route::get('/', [PageController::class, 'home'])->name('home');

Route::middleware('guest')->group(function () {
    Route::get('/login', [LoginController::class, 'create'])
        ->name('login');
    Route::post('/login', [LoginController::class, 'store'])
        ->name('login.store')
        ->middleware('throttle:5,1');
    Route::post('/register', [RegisterController::class, 'store'])
        ->name('register.store');
});

Route::middleware('auth')->group(function () {
    Route::post('/logout', [LoginController::class, 'destroy'])
        ->name('logout');
    Route::post('/loans/{loan}/return', ReturnLoanController::class)
        ->name('loans.return');
    Route::get('/profilo', fn () => 'Ciao, '.auth()->user()->name)
        ->name('profile');
});

Route::resource('books', BookController::class)
    ->except(['index', 'show'])
    ->middleware('auth');

Route::resource('books', BookController::class)
    ->only(['index', 'show']);

Route::livewire('/authors/create', 'pages::authors.create')
    ->middleware('auth')
    ->name('authors.create');

Route::prefix('spa')->name('spa.')->group(function () {
    Route::resource('books', App\Http\Controllers\Spa\BookController::class)
        ->only(['index', 'create', 'store']);
});
