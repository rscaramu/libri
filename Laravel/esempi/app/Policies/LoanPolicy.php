<?php

namespace App\Policies;

use App\Models\Loan;
use App\Models\User;

class LoanPolicy
{
    public function view(User $user, Loan $loan): bool
    {
        return $user->isStaff() || $loan->user_id === $user->id;
    }

    public function create(User $user): bool
    {
        return $user->loans()->open()->count()
            < config('scaffale.max_prestiti');
    }

    public function return(User $user, Loan $loan): bool
    {
        return $user->isStaff();
    }
}
