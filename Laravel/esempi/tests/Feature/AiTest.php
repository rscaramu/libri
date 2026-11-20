<?php

namespace Tests\Feature;

use App\Ai\Agents\LibraryAssistant;
use App\Ai\Tools\SearchCatalog;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Ai\Embeddings;
use Laravel\Ai\Tools\Request;
use Tests\TestCase;

class AiTest extends TestCase
{
    use RefreshDatabase;

    public function test_agent(): void
    {
        $this->seed(\Database\Seeders\CatalogSeeder::class);
        LibraryAssistant::fake(['Abbiamo «Il nome della rosa», disponibile.']);
        $r = LibraryAssistant::make()->prompt('Avete libri di Eco sulla rosa?');
        $this->assertSame('Abbiamo «Il nome della rosa», disponibile.', (string) $r);
        LibraryAssistant::assertPrompted(fn ($p) => $p->contains('Eco'));
        $out = (new SearchCatalog)->handle(new Request(['query' => 'rosa']));
        fwrite(STDERR, "\nTOOL:".$out."\n".get_class($r)."\n");
        $this->assertStringContainsString('Umberto Eco (1980): disponibile', (string) $out);
        Embeddings::fake();
        $e = Embeddings::for(['Napa'])->generate();
        fwrite(STDERR, 'EMB:'.count($e->embeddings[0])."\n");
    }
}
