<?php

namespace App\Http\Controllers;

use App\Models\Loan;
use Illuminate\Http\RedirectResponse;

class ReturnLoanController extends Controller
{
    public function __invoke(Loan $loan): RedirectResponse
    {
        $loan->update(['returned_at' => now()]);

        return back()->with('status', 'Libro restituito.');
    }
}
