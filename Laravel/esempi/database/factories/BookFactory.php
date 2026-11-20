<?php

namespace Database\Factories;

use App\Models\Book;
use Illuminate\Database\Eloquent\Factories\Factory;
use App\Enums\Format;
use App\Models\Author;

/**
 * @extends Factory<Book>
 */
class BookFactory extends Factory
{
    public function definition(): array
    {
        return [
            'author_id' => Author::factory(),
            'title' => fake()->sentence(3),
            'isbn' => fake()->unique()->isbn13(),
            'year' => fake()->numberBetween(1900, 2026),
            'pages' => fake()->numberBetween(80, 900),
            'price' => fake()->randomFloat(2, 5, 60),
            'format' => fake()->randomElement(Format::cases()),
            'available' => true,
        ];
    }
}
