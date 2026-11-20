<?php
namespace App\Policies;
use App\Models\User;
class AuthorPolicy { public function create(User $user): bool { return $user->isStaff(); } }
