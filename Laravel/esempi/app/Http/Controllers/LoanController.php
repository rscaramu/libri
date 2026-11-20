<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Routing\Attributes\Controllers\Authorize;
use Illuminate\Routing\Attributes\Controllers\Middleware;

#[Middleware('auth')]
class LoanController extends Controller
{
    public function index()
    {
        // richiede un utente autenticato
    }

    #[Middleware('throttle:10,1')]
    #[Authorize('create', [\App\Models\Loan::class])]
    public function store(Book $book)
    {
        // autenticato, limitato e autorizzato
    }
}
