# Manuale completo di LARAVEL — materiale per i lettori

Materiale di accompagnamento al volume *Manuale completo di LARAVEL. Dai fondamenti del framework alle applicazioni web moderne con Eloquent, Blade, Livewire, Inertia e API*, di Roberto Scaramuzzino.

## Contenuto

- `esempi/` — il codice del progetto guida *Scaffale* (catalogo di una biblioteca): modelli, migrazioni, factory, seeder, controller, policy, eventi, job, posta, notifiche, componenti Blade e Livewire, risorse API, agenti dell’AI SDK, comandi Artisan e test.
- `prompt/prompt.md` — i 102 prompt dei paragrafi «Con l’IA», capitolo per capitolo.
- `ERRATA.md` — correzioni segnalate dopo la pubblicazione.

## Come usare gli esempi

La cartella `esempi/` contiene i file dell’applicazione, non le dipendenze. Per provarli:

1. create un progetto nuovo: `composer create-project laravel/laravel scaffale` (Laravel 13, PHP 8.3 o successivo);
2. installate i pacchetti usati nei capitoli che vi interessano: `composer require livewire/livewire inertiajs/inertia-laravel laravel/sanctum laravel/ai` e `composer require --dev laravel/boost`;
3. copiate nel progetto i file di `esempi/`, sovrascrivendo quelli esistenti;
4. eseguite `php artisan migrate:fresh --seed` e poi `php artisan test`.

Il database predefinito è SQLite: non occorre installare altro. Gli utenti creati dai seeder hanno tutti la password `password`.

## Versioni di riferimento

Laravel 13, PHP 8.3, Livewire 4, Inertia 3, Sanctum 4, Laravel AI SDK 1.

## Licenza

Il codice degli esempi può essere usato liberamente a scopo di studio e nei propri progetti. Il testo del libro non è incluso ed è protetto dal diritto d’autore.
