<?php

namespace App\Policies;

use App\Models\Book;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class BookPolicy
{
    public function viewAny(?User $user): bool
    {
        return true;
    }

    public function view(?User $user, Book $book): bool
    {
        return true;
    }

    public function create(User $user): bool
    {
        return $user->isStaff();
    }

    public function update(User $user, Book $book): bool
    {
        return $user->isStaff();
    }

    public function delete(User $user, Book $book): Response
    {
        if (! $user->isStaff()) {
            return Response::deny();
        }

        return $book->loans()->open()->exists()
            ? Response::deny('Il libro ha prestiti in corso.')
            : Response::allow();
    }
}
