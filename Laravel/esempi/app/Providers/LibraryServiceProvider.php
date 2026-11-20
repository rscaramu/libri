<?php

namespace App\Providers;

use App\Contracts\IsbnLookup;
use App\Services\FakeLookup;
use App\Services\OpenLibraryLookup;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Support\ServiceProvider;

class LibraryServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->singleton(
            IsbnLookup::class,
            function (Application $app) {
                if ($app->environment('testing')) {
                    return new FakeLookup;
                }

                return new OpenLibraryLookup(
                    config('services.openlibrary.url'),
                );
            }
        );
    }

    public function boot(): void
    {
        //
    }
}
