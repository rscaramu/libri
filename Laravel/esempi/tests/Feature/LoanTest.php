<?php

namespace Tests\Feature;

use App\Events\LoanCreated;
use App\Mail\LoanConfirmed;
use App\Models\Loan;
use App\Notifications\LoanOverdue;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Queue;
use Tests\TestCase;

class LoanTest extends TestCase
{
    use RefreshDatabase;

    public function test_a_loan_gets_a_default_due_date(): void
    {
        $this->travelTo('2026-03-01');

        $loan = Loan::factory()->create([
            'loaned_at' => null,
            'due_at' => null,
        ]);

        $this->assertSame(
            '2026-03-31', $loan->due_at->toDateString()
        );
    }

    public function test_a_loan_becomes_overdue(): void
    {
        $loan = Loan::factory()->create([
            'loaned_at' => '2026-03-01',
            'due_at' => '2026-03-31',
        ]);

        $this->travelTo('2026-03-31');
        $this->assertFalse($loan->isOverdue());

        $this->travelTo('2026-04-10');
        $this->assertTrue($loan->isOverdue());
        $this->assertSame(10, $loan->daysLate());
    }

    public function test_reminders_are_sent_for_overdue_loans(): void
    {
        Notification::fake();

        $overdue = Loan::factory()->overdue()->create();
        $open = Loan::factory()->create();

        $this->artisan('loans:remind')
            ->expectsOutputToContain('Solleciti accodati: 1.')
            ->assertSuccessful();

        Notification::assertSentTo(
            $overdue->user, LoanOverdue::class
        );
        Notification::assertNotSentTo(
            $open->user, LoanOverdue::class
        );
    }
}
