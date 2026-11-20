<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;
use Illuminate\Database\Eloquent\Relations\HasOne;

#[Fillable(['name', 'country', 'birth_year'])]
class Author extends Model
{
    use HasFactory;

    public function books(): HasMany
    {
        return $this->hasMany(Book::class);
    }

    public function loans(): HasManyThrough
    {
        return $this->hasManyThrough(Loan::class, Book::class);
    }

    public function latestBook(): HasOne
    {
        return $this->hasOne(Book::class)->latestOfMany('year');
    }
}
