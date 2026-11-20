<?php

namespace App\Services;

use App\Contracts\IsbnLookup;
use Illuminate\Support\Facades\Http;

class OpenLibraryLookup implements IsbnLookup
{
    public function __construct(
        private string $baseUrl,
    ) {}

    public function find(string $isbn): ?array
    {
        $response = Http::timeout(5)
            ->get("{$this->baseUrl}/isbn/{$isbn}.json");

        if ($response->failed()) {
            return null;
        }

        return [
            'title' => $response->json('title'),
            'year' => (int) substr(
                (string) $response->json('publish_date'), -4
            ),
        ];
    }
}
