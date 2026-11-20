<?php

namespace App\Console\Commands;

use App\Jobs\SendLoanReminder;
use App\Models\Loan;
use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;

#[Signature('loans:remind
    {--days=1 : Giorni minimi di ritardo}
    {--dry-run : Mostra i prestiti senza inviare nulla}')]
#[Description('Invia i solleciti per i prestiti scaduti')]
class SendOverdueReminders extends Command
{
    public function handle(): int
    {
        $days = (int) $this->option('days');

        $loans = Loan::overdue()
            ->where('due_at', '<=', today()->subDays($days))
            ->with(['book', 'user'])
            ->get();

        if ($loans->isEmpty()) {
            $this->info('Nessun prestito da sollecitare.');

            return self::SUCCESS;
        }

        $this->table(
            ['Prestito', 'Libro', 'Utente', 'Ritardo'],
            $loans->map(fn (Loan $loan) => [
                $loan->id,
                $loan->book->title,
                $loan->user->email,
                $loan->daysLate() . ' gg',
            ]),
        );

        if ($this->option('dry-run')) {
            $this->warn('Prova: nessun sollecito inviato.');

            return self::SUCCESS;
        }

        $loans->each(
            fn (Loan $loan) => SendLoanReminder::dispatch($loan)
        );

        $this->info("Solleciti accodati: {$loans->count()}.");

        return self::SUCCESS;
    }
}
