<?php

namespace App\Http\Resources\JsonApi;

use Illuminate\Http\Resources\JsonApi\JsonApiResource;

class BookResource extends JsonApiResource
{
    public $attributes = [
        'title',
        'year',
        'pages',
        'available',
    ];

    public $relationships = [
        'author' => AuthorResource::class,
    ];
}
