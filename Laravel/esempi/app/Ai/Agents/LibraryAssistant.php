<?php

namespace App\Ai\Agents;

use App\Ai\Tools\SearchCatalog;
use Laravel\Ai\Attributes\MaxSteps;
use Laravel\Ai\Attributes\Temperature;
use Laravel\Ai\Contracts\Agent;
use Laravel\Ai\Contracts\HasTools;
use Laravel\Ai\Promptable;
use Stringable;

#[MaxSteps(5)]
#[Temperature(0.2)]
class LibraryAssistant implements Agent, HasTools
{
    use Promptable;

    public function instructions(): Stringable|string
    {
        return <<<'TXT'
        Sei l'assistente della biblioteca Scaffale. Rispondi
        in italiano, in modo breve e cortese. Per sapere quali
        libri sono in catalogo usa sempre lo strumento di
        ricerca: non citare mai titoli che non hai trovato.
        TXT;
    }

    public function tools(): iterable
    {
        return [
            new SearchCatalog,
        ];
    }
}
