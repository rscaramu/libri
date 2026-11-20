<?php

namespace Database\Seeders;

use App\Models\Book;
use App\Models\Loan;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call(CatalogSeeder::class);

        $admin = User::factory()->create([
            'name' => 'Bibliotecaria',
            'email' => 'biblioteca@example.com',
        ]);

        $soci = User::factory()->count(5)->create();

        Book::take(4)->get()->each(function (Book $book) use ($soci) {
            Loan::factory()->create([
                'book_id' => $book->id,
                'user_id' => $soci->random()->id,
            ]);

            $book->update(['available' => false]);
        });
    }
}
