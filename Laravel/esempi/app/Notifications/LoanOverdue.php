<?php

namespace App\Notifications;

use App\Models\Loan;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class LoanOverdue extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public Loan $loan,
    ) {}

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Prestito scaduto')
            ->greeting("Gentile {$notifiable->name},")
            ->line("il prestito di «{$this->loan->book->title}»"
                . " è scaduto da {$this->loan->daysLate()} giorni.")
            ->action('I miei prestiti', url('/loans'))
            ->line('Vi preghiamo di restituire il libro.');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'loan_id' => $this->loan->id,
            'title' => $this->loan->book->title,
            'days_late' => $this->loan->daysLate(),
        ];
    }
}
