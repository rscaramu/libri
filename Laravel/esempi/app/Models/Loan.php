<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Scope;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['book_id', 'user_id', 'loaned_at', 'due_at', 'returned_at'])]
class Loan extends Model
{
    use HasFactory;

    protected function casts(): array
    {
        return [
            'loaned_at' => 'date',
            'due_at' => 'date',
            'returned_at' => 'date',
        ];
    }

    public function book(): BelongsTo
    {
        return $this->belongsTo(Book::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    #[Scope]
    protected function open(Builder $query): void
    {
        $query->whereNull('returned_at');
    }

    #[Scope]
    protected function overdue(Builder $query): void
    {
        $query->whereNull('returned_at')
            ->where('due_at', '<', today());
    }

    public function isOverdue(): bool
    {
        return $this->returned_at === null
            && $this->due_at->isPast();
    }

    public function daysLate(): int
    {
        return $this->isOverdue()
            ? (int) $this->due_at->diffInDays(today())
            : 0;
    }

    protected static function booted(): void
    {
        static::creating(function (Loan $loan) {
            $loan->loaned_at ??= today();
            $loan->due_at ??= today()->addDays(
                config('scaffale.giorni_prestito', 30)
            );
        });
    }
}
