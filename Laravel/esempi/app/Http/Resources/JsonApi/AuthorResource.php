<?php

namespace App\Http\Resources\JsonApi;

use Illuminate\Http\Resources\JsonApi\JsonApiResource;

class AuthorResource extends JsonApiResource
{
    public $attributes = [
        'name',
        'country',
    ];
}
