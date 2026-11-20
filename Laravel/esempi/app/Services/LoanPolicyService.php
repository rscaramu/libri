<?php

namespace App\Services;

use Illuminate\Container\Attributes\Config;
use Illuminate\Support\Carbon;

class LoanPolicyService
{
    public function __construct(
        #[Config('scaffale.giorni_prestito')] private int $days,
        #[Config('scaffale.max_prestiti')] private int $max,
    ) {}

    public function dueDate(?Carbon $from = null): Carbon
    {
        return ($from ?? today())->copy()->addDays($this->days);
    }

    public function maxLoans(): int
    {
        return $this->max;
    }
}
