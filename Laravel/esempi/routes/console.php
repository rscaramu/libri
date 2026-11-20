<?php

use App\Models\Loan;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('loans:count', function () {
    $this->info('Prestiti aperti: ' . Loan::open()->count());
})->purpose('Conta i prestiti aperti');

Schedule::command('loans:remind')
    ->weekdays()
    ->dailyAt('08:30')
    ->withoutOverlapping()
    ->onOneServer();

Schedule::command('model:prune')->daily();
Schedule::command('queue:prune-failed --hours=168')->weekly();

Schedule::call(fn () => cache()->forget('statistiche.catalogo'))
    ->hourly()
    ->name('statistiche')
    ->description('Azzera le statistiche in cache');
