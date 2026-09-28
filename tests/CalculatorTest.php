<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;
use SrpskeBanke\Domain\Calculator;
use SrpskeBanke\Support\CurrentValue;
use SrpskeBanke\Support\Money;

require_once dirname(__DIR__) . '/src/bootstrap.php';

final class CalculatorTest extends TestCase
{
    public function test_missing_package_is_not_zero(): void
    {
        $r = Calculator::monthly(['ebanking_transfers' => 5], ['package' => null, 'ebanking_transfer' => 20]);
        $this->assertFalse($r['complete']);
        $this->assertNull($r['monthly']);
    }

    public function test_complete_sum(): void
    {
        $r = Calculator::monthly(
            ['ebanking_transfers' => 5, 'atm_own' => 2],
            ['package' => 390, 'ebanking_transfer' => 20, 'instant' => 0, 'branch' => 150, 'atm_own' => 150, 'atm_other' => 200]
        );
        $this->assertTrue($r['complete']);
        $this->assertSame(790.0, $r['monthly']);
        $this->assertSame(9480.0, $r['yearly']);
    }

    public function test_percentage_fee_needs_base(): void
    {
        $r = Money::computeFee(null, null, 1.5, 200, 5000);
        $this->assertFalse($r['complete']);
        $this->assertNull($r['total']);
    }

    public function test_promotion_expiry(): void
    {
        $promo = ['is_enabled' => 1, 'valid_from' => '2026-01-01', 'valid_until' => '2026-01-31', 'start_at' => null, 'end_at' => null];
        $this->assertFalse(CurrentValue::promotionPublic($promo, '2026-02-01 00:00:00'));
        $this->assertTrue(CurrentValue::promotionPublic($promo, '2026-01-15 12:00:00'));
    }

    public function test_future_tariff_not_current(): void
    {
        $this->assertFalse(CurrentValue::isCurrent('2026-10-01', null, '2026-09-28'));
        $this->assertTrue(CurrentValue::isCurrent('2026-01-01', '2026-12-31', '2026-09-28'));
    }
}
