<?php

namespace App\Http\Controllers;

use Illuminate\View\View;

class PageController extends Controller
{
    public function home(): View
    {
        return view('welcome');
    }

    public function info(): View
    {
        return view('info', [
            'nome' => config('app.name'),
            'libri' => 128,
        ]);
    }
}
