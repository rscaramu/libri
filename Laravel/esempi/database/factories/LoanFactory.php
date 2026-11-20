<?php

namespace Database\Factories;

use App\Models\Book;
use App\Models\Loan;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Loan>
 */
class LoanFactory extends Factory
{
    public function definition(): array
    {
        $inizio = fake()->dateTimeBetween('-20 days');

        return [
            'book_id' => Book::factory(),
            'user_id' => User::factory(),
            'loaned_at' => $inizio,
            'due_at' => (clone $inizio)->modify('+30 days'),
            'returned_at' => null,
        ];
    }

    public function overdue(): static
    {
        return $this->state(fn (array $attributes) => [
            'loaned_at' => now()->subDays(45),
            'due_at' => now()->subDays(15),
            'returned_at' => null,
        ]);
    }

    public function returned(): static
    {
        return $this->state(fn (array $attributes) => [
            'returned_at' => now()->subDay(),
        ]);
    }
}
