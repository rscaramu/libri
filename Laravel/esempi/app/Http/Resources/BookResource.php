<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'year' => $this->year,
            'pages' => $this->pages,
            'price' => (float) $this->price,
            'format' => $this->format->value,
            'available' => $this->available,
            'author' => new AuthorResource(
                $this->whenLoaded('author')
            ),
            'categories' => $this->whenLoaded(
                'categories',
                fn () => $this->categories->pluck('name'),
            ),
            'links' => [
                'self' => route('api.books.show', $this->id),
            ],
        ];
    }
}
