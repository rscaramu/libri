<?php

namespace App\Models;

use App\Enums\Format;
use App\Observers\BookObserver;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\ObservedBy;
use Illuminate\Database\Eloquent\Attributes\Scope;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Support\Number;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

#[ObservedBy([BookObserver::class])]
#[Fillable([
    'author_id', 'title', 'isbn', 'year', 'pages',
    'price', 'format', 'description', 'available',
])]
class Book extends Model
{
    use HasFactory, SoftDeletes;

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'available' => 'boolean',
            'format' => Format::class,
        ];
    }

    public function author(): BelongsTo
    {
        return $this->belongsTo(Author::class);
    }

    public function categories(): BelongsToMany
    {
        return $this->belongsToMany(Category::class);
    }

    public function loans(): HasMany
    {
        return $this->hasMany(Loan::class);
    }

    #[Scope]
    protected function available(Builder $query): void
    {
        $query->where('available', true);
    }

    #[Scope]
    protected function publishedBetween(
        Builder $query,
        int $from,
        int $to,
    ): void {
        $query->whereBetween('year', [$from, $to]);
    }

    #[Scope]
    protected function search(Builder $query, ?string $term): void
    {
        $query->when($term, fn (Builder $q) => $q
            ->whereAny(['title', 'isbn'], 'like', "%{$term}%"));
    }

    protected function title(): Attribute
    {
        return Attribute::make(
            set: fn (string $value) => trim($value),
        );
    }

    protected function formattedPrice(): Attribute
    {
        return Attribute::make(
            get: fn () => Number::currency(
                (float) $this->price, 'EUR', 'it'
            ),
        );
    }

    protected function isClassic(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->year < 1970,
        );
    }
}
