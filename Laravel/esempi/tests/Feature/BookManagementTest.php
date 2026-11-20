<?php

namespace Tests\Feature;

use App\Models\Author;
use App\Models\Book;
use App\Models\Loan;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BookManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_the_catalog_is_public(): void
    {
        $book = Book::factory()->create(['title' => 'Dune']);

        $this->withoutVite()
            ->get('/books')
            ->assertOk()
            ->assertSee('Dune');
    }

    public function test_guests_cannot_create_books(): void
    {
        $this->post('/books', ['title' => 'Dune'])
            ->assertRedirect('/login');

        $this->assertDatabaseCount('books', 0);
    }

    public function test_members_cannot_create_books(): void
    {
        $member = User::factory()->create();

        $this->actingAs($member)
            ->post('/books', $this->validData())
            ->assertForbidden();
    }

    public function test_a_librarian_can_create_a_book(): void
    {
        $librarian = User::factory()->librarian()->create();

        $this->actingAs($librarian)
            ->post('/books', $this->validData())
            ->assertRedirect()
            ->assertSessionHas('status', 'Libro salvato.');

        $this->assertDatabaseHas('books', [
            'title' => 'Dune',
            'year' => 1965,
        ]);
    }

    public function test_the_title_is_required(): void
    {
        $librarian = User::factory()->librarian()->create();

        $this->actingAs($librarian)
            ->post('/books', $this->validData(['title' => '']))
            ->assertSessionHasErrors('title');

        $this->assertDatabaseCount('books', 0);
    }

    public function test_a_book_on_loan_cannot_be_deleted(): void
    {
        $librarian = User::factory()->librarian()->create();
        $loan = Loan::factory()->create();

        $this->actingAs($librarian)
            ->delete("/books/{$loan->book_id}")
            ->assertForbidden();

        $this->assertNotSoftDeleted($loan->book);
    }

    private function validData(array $overrides = []): array
    {
        return [
            'title' => 'Dune',
            'author_id' => Author::factory()->create()->id,
            'year' => 1965,
            'price' => 12.5,
            'format' => 'cartaceo',
            ...$overrides,
        ];
    }
}
