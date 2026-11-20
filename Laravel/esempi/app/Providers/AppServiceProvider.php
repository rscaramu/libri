<?php

namespace App\Providers;

use App\Enums\Role;
use App\Models\User;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        Gate::define('view-reports', function (User $user) {
            return $user->isStaff();
        });

        Gate::before(function (User $user, string $ability) {
            if ($user->role === Role::Direttore) {
                return true;
            }
        });
    }
}
