<?php

namespace Tests\Unit;

use App\Services\IsbnChecker;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

class IsbnCheckerTest extends TestCase
{
    public function test_a_valid_isbn_is_accepted(): void
    {
        $checker = new IsbnChecker;

        $this->assertTrue($checker->isValid('9788845292613'));
    }

    #[DataProvider('invalidCodes')]
    public function test_invalid_codes_are_rejected(
        string $code,
    ): void {
        $this->assertFalse((new IsbnChecker)->isValid($code));
    }

    public static function invalidCodes(): array
    {
        return [
            'cifra di controllo errata' => ['9788845292614'],
            'troppo corto' => ['97888452926'],
            'con lettere' => ['97888452926AB'],
            'vuoto' => [''],
        ];
    }
}
