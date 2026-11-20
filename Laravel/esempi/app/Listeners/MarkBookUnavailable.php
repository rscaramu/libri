<?php

namespace App\Listeners;

use App\Events\LoanCreated;

class MarkBookUnavailable
{
    public function handle(LoanCreated $event): void
    {
        $event->loan->book->update(['available' => false]);
    }
}
