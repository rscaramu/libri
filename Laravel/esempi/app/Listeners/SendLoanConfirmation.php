<?php

namespace App\Listeners;

use App\Events\LoanCreated;
use Illuminate\Support\Facades\Log;

class SendLoanConfirmation
{
    public function handle(LoanCreated $event): void
    {
        Log::info('Conferma di prestito', [
            'prestito' => $event->loan->id,
            'utente' => $event->loan->user->email,
        ]);
    }
}
