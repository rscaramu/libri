<?php

namespace App\View\Components;

use App\Models\Loan;
use Illuminate\Contracts\View\View;
use Illuminate\View\Component;

class LoanBadge extends Component
{
    public function __construct(
        public Loan $loan,
    ) {}

    public function label(): string
    {
        return match (true) {
            $this->loan->returned_at !== null => 'Restituito',
            $this->loan->due_at->isPast() => 'In ritardo',
            default => 'In corso',
        };
    }

    public function overdue(): bool
    {
        return $this->loan->returned_at === null
            && $this->loan->due_at->isPast();
    }

    public function render(): View
    {
        return view('components.loan-badge');
    }
}
