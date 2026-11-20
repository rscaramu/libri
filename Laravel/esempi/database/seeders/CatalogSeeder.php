<?php

namespace Database\Seeders;

use App\Models\Author;
use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CatalogSeeder extends Seeder
{
    private const CATALOGO = [
        'Umberto Eco|IT|1932' => [
            ['Il nome della rosa', 1980, 503, 14.00,
                ['Romanzo', 'Giallo']],
            ['Il pendolo di Foucault', 1988, 509, 15.00,
                ['Romanzo']],
            ['Sei passeggiate nei boschi narrativi', 1994, 183,
                12.00, ['Saggio']],
        ],
        'Italo Calvino|IT|1923' => [
            ['Il barone rampante', 1957, 265, 12.50,
                ['Romanzo']],
            ['Le cosmicomiche', 1965, 188, 11.00,
                ['Racconti']],
            ['Lezioni americane', 1988, 150, 10.50,
                ['Saggio']],
        ],
        'Elsa Morante|IT|1912' => [
            ['La Storia', 1974, 665, 16.00, ['Romanzo']],
        ],
        'Primo Levi|IT|1919' => [
            ['Se questo è un uomo', 1947, 209, 11.50,
                ['Memorie']],
            ['Il sistema periodico', 1975, 261, 12.00,
                ['Racconti', 'Memorie']],
        ],
        'Natalia Ginzburg|IT|1916' => [
            ['Lessico famigliare', 1963, 261, 11.00,
                ['Romanzo', 'Memorie']],
        ],
    ];

    public function run(): void
    {
        foreach (self::CATALOGO as $chiave => $libri) {
            [$nome, $paese, $anno] = explode('|', $chiave);

            $author = Author::create([
                'name' => $nome,
                'country' => $paese,
                'birth_year' => (int) $anno,
            ]);

            foreach ($libri as [$titolo, $a, $p, $prezzo, $cat]) {
                $book = $author->books()->create([
                    'title' => $titolo,
                    'year' => $a,
                    'pages' => $p,
                    'price' => $prezzo,
                ]);

                $ids = collect($cat)->map(
                    fn ($n) => Category::firstOrCreate(
                        ['slug' => Str::slug($n)],
                        ['name' => $n],
                    )->id
                );

                $book->categories()->attach($ids);
            }
        }
    }
}
