<?php
declare(strict_types=1);
require dirname(__DIR__) . '/src/bootstrap.php';
use SrpskeBanke\Config;
use SrpskeBanke\Domain\BankRepository;
use SrpskeBanke\Domain\Calculator;
use SrpskeBanke\Admin\Auth;
use SrpskeBanke\Security\Csrf;
use SrpskeBanke\Support\Money;

$secure = sb_env('SESSION_SECURE', '1') === '1';
session_name(sb_env('SESSION_NAME', 'srpskebanke'));
session_set_cookie_params(['lifetime'=>0,'path'=>'/','secure'=>$secure,'httponly'=>true,'samesite'=>sb_env('SESSION_SAMESITE','Lax')]);
session_start();
header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: strict-origin-when-cross-origin');
header('X-Frame-Options: SAMEORIGIN');

$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$path = rtrim($path, '/') ?: '/';
$banksRepo = new BankRepository();

function page(string $title, string $html): void {
    $site = Config::appName();
    echo '<!DOCTYPE html><html lang="sr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">';
    echo '<title>'.sb_h($title).'</title></head><body>';
    echo '<header><a href="/">'.sb_h($site).'</a> <nav><a href="/banke">Banke</a> <a href="/uporedi">Uporedi</a> <a href="/kalkulator">Kalkulator</a> <a href="/metodologija">Metodologija</a></nav></header>';
    echo '<main>'.$html.'</main>';
    echo '<footer><p>Podaci su informativnog karaktera. Trudimo se da informacije budu azurne i proveravamo ih prema zvanicnim izvorima NBS i banaka. Pre zakljucivanja ugovora proverite trenutno vazeci uslov kod banke.</p></footer></body></html>';
}

if ($path === '/') {
    $banks = $banksRepo->allActive();
    $html = '<h1>Uporedite banke u Srbiji na osnovu proverljivih podataka.</h1><form action="/banke" method="get"><input name="q" placeholder="Koju banku ili uslugu trazite?"><button>Trazi</button></form><h2>Banke u NBS registru</h2><p>'.count($banks).' aktivnih zapisa. Naknade nisu unete dok ne prodju proveru.</p><ul>';
    foreach ($banks as $b) $html .= '<li><a href="/banka/'.sb_h($b['slug']).'">'.sb_h($b['brand_name']).'</a></li>';
    $html .= '</ul>';
    page(Config::appName(), $html); exit;
}
if ($path === '/banke') {
    $q = trim((string)($_GET['q'] ?? ''));
    $list = $q === '' ? $banksRepo->allActive() : $banksRepo->search($q);
    $html = '<h1>Banke</h1><form method="get"><input name="q" value="'.sb_h($q).'"><button>Trazi</button></form><ul>';
    foreach ($list as $b) $html .= '<li><a href="/banka/'.sb_h($b['slug']).'">'.sb_h($b['brand_name']).'</a> — '.sb_h($b['legal_name']).'</li>';
    $html .= '</ul>';
    page('Banke | '.Config::appName(), $html); exit;
}
if (preg_match('#^/banka/([a-z0-9-]+)$#', $path, $m)) {
    $b = $banksRepo->findBySlug($m[1]);
    if (!$b) { http_response_code(404); page('Nije pronadjeno', '<h1>Banka nije pronadjena.</h1>'); exit; }
    $html = '<h1>'.sb_h($b['brand_name']).'</h1><p>'.sb_h($b['legal_name']).'</p>';
    $html .= '<p>Provereno: '.sb_h((string)$b['last_verified_at']).' · '.sb_h((string)$b['verification_status']).'</p>';
    $html .= '<table><tr><th>SWIFT/BIC</th><td>'.sb_h((string)$b['swift_bic']).'</td></tr>';
    $html .= '<tr><th>NBS racun</th><td>'.sb_h((string)$b['nbs_account']).'</td></tr>';
    $html .= '<tr><th>Maticni broj</th><td>'.sb_h((string)$b['registration_number']).'</td></tr>';
    $html .= '<tr><th>Sediste</th><td>'.sb_h((string)$b['headquarters_address']).'</td></tr>';
    $html .= '<tr><th>Mesecno odrzavanje</th><td>'.sb_h(sb_missing()).'</td></tr></table>';
    $html .= '<p>Izvor: NBS pregled racuna i BIC, 1.9.2026.</p>';
    page($b['brand_name'].' | '.Config::appName(), $html); exit;
}
if ($path === '/kalkulator') {
    $slug = (string)($_GET['bank'] ?? '');
    $bank = $slug !== '' ? $banksRepo->findBySlug($slug) : null;
    $html = '<h1>Koliko bi mene kostala ova banka?</h1><form method="get"><select name="bank"><option value="">---</option>';
    foreach ($banksRepo->allActive() as $b) {
        $sel = $slug === $b['slug'] ? ' selected' : '';
        $html .= '<option value="'.sb_h($b['slug']).'"'.$sel.'>'.sb_h($b['brand_name']).'</option>';
    }
    $html .= '</select><button>Izracunaj</button></form>';
    if ($bank) {
        $r = Calculator::monthly(['ebanking_transfers'=>(int)($_GET['ebanking'] ?? 0)], ['package'=>null]);
        $html .= '<p>'.sb_h(sb_missing()).' Procena nije kompletna. NULL nije 0 RSD.</p>';
    }
    page('Kalkulator | '.Config::appName(), $html); exit;
}
if ($path === '/uporedi') {
    page('Uporedi | '.Config::appName(), '<h1>Uporedi</h1><p>Izaberite 2 do 5 banaka. Nema subjektivnog skora.</p>'); exit;
}
if (in_array($path, ['/metodologija','/izvori','/o-projektu','/promocije','/racuni','/kartice','/krediti','/stednja','/naknade','/digitalno-bankarstvo','/ips','/promene','/privatnost'], true)) {
    page(trim($path,'/').' | '.Config::appName(), '<h1>'.sb_h(trim($path,'/')).'</h1><p>'.sb_h(sb_missing()).'</p>'); exit;
}
if ($path === '/admin/login' && $_SERVER['REQUEST_METHOD'] === 'POST' && Csrf::check($_POST['_csrf'] ?? null) && Auth::attempt((string)($_POST['email'] ?? ''), (string)($_POST['password'] ?? ''))) {
    header('Location: /admin'); exit;
}
if ($path === '/admin/login') {
    page('Admin', '<form method="post">'.Csrf::field().'<input type="email" name="email"><input type="password" name="password"><button>Prijava</button></form>'); exit;
}
if ($path === '/admin') {
    if (!Auth::user()) { header('Location: /admin/login'); exit; }
    page('Admin', '<h1>Data quality</h1><p>'.$banksRepo->countActive().' active banks / NBS count 19</p>'); exit;
}
http_response_code(404);
page('Nije pronadjeno', '<h1>Stranica nije pronadjena.</h1>');
