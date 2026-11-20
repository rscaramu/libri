<?php

namespace App\Jobs;

use App\Models\Loan;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Queue\Attributes\Backoff;
use Illuminate\Queue\Attributes\Timeout;
use Illuminate\Queue\Attributes\Tries;
use Illuminate\Support\Facades\Log;
use Throwable;

#[Tries(3)]
#[Backoff([60, 300])]
#[Timeout(30)]
class SendLoanReminder implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public Loan $loan,
    ) {}

    public function handle(): void
    {
        if ($this->loan->returned_at !== null) {
            return;
        }

        $this->loan->user->notify(new \App\Notifications\LoanOverdue($this->loan));
        Log::info("Sollecito inviato", [
            'prestito' => $this->loan->id,
            'giorni' => $this->loan->daysLate(),
        ]);
    }

    public function failed(?Throwable $exception): void
    {
        Log::error('Sollecito non inviato', [
            'prestito' => $this->loan->id,
            'errore' => $exception?->getMessage(),
        ]);
    }
}
