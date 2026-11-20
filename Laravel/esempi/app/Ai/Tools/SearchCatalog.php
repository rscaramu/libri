<?php

namespace App\Ai\Tools;

use App\Models\Book;
use Illuminate\Contracts\JsonSchema\JsonSchema;
use Laravel\Ai\Contracts\Tool;
use Laravel\Ai\Tools\Request;
use Stringable;

class SearchCatalog implements Tool
{
    public function description(): Stringable|string
    {
        return 'Cerca nel catalogo della biblioteca i libri'
            . ' il cui titolo contiene il testo indicato.';
    }

    public function handle(Request $request): Stringable|string
    {
        $books = Book::with('author:id,name')
            ->search($request['query'])
            ->limit(5)
            ->get();

        if ($books->isEmpty()) {
            return 'Nessun libro trovato.';
        }

        return $books->map(fn (Book $book) => sprintf(
            '%s, di %s (%d): %s',
            $book->title,
            $book->author->name,
            $book->year,
            $book->available ? 'disponibile' : 'in prestito',
        ))->implode("\n");
    }

    public function schema(JsonSchema $schema): array
    {
        return [
            'query' => $schema->string()
                ->description('Testo da cercare nel titolo')
                ->required(),
        ];
    }
}
