# srpske-banke

Nezavisni portal za sve banke i bankarske usluge u Republici Srbiji.

Registar. Upoređivač. Baza naknada. Baza promocija. Kalkulator stvarnog troška. Istorija promena. Baza izvora. Komentari korisnika.

Nije novinski portal. Nije ranking. Nije "najbolja banka".

Live target stack: Nginx + PHP-FPM + MariaDB on CloudPanel.

## Glavno pravilo

**Tačnost > brzina > količina sadržaja.**

Nikada ne izmišljati nedostajući podatak.

Ako pouzdan podatak ne postoji, javna strana piše:

- `Nema dovoljno pouzdanih podataka`
- ili `Podatak nije pronađen u zvaničnim izvorima.`

`NULL` nije `0 RSD`.

Poverenje je proizvod.

## Šta ovaj commit radi

Phase 1–3 kičma, bez lažnih cena.

- schema za ceo model (računi, kartice, naknade, krediti, štednja, digitalno, IPS, promocije, izvori, konflikti, audit)
- seed 19 aktivnih banaka iz NBS registra (bilans 30.6.2026. + spisak + RTGS/BIC pregled 1.9.2026.)
- javne SSR strane
- poređenje 2–5 banaka
- kalkulator koji odbija da nedostajuću stavku tretira kao nulu
- admin (super admin / editor / bank editor / reviewer)
- import adapteri + diff + pending review
- read-only `/api/v1`
- Remark42 kao odvojeni servis (dokumentovano, nije vendor u ovom repou)

Finansijske cene **nisu** seedovane. Tabela naknada ostaje prazna dok admin ili importer ne unese vrednost sa izvorom.

## Izvori — prioritet

1. Narodna banka Srbije (`nbs.rs`, `pputarifa.nbs.rs`, `ips.nbs.rs`)
2. Zvanični sajt banke / tarifnik / PDF
3. AOD, kartične šeme, državni registri
4. Mediji i komentari — samo lead, nikad jedini dokaz trenutne cene

NBS uporedni pregled naknada **nije** kompletan tarifnik banke. NBS to i sama kaže.

## Brzi start

```bash
cp .env.example .env
mysql -u USER -p DB < sql/001_schema.sql
mysql -u USER -p DB < sql/002_seed_taxonomy.sql
mysql -u USER -p DB < sql/003_seed_banks.sql
```

CloudPanel document root: `public/`

PHP 8.2+, MariaDB 10.11+ ili MySQL 8.

Prvi admin se pravi iz `.env` (`ADMIN_EMAIL`, `ADMIN_PASSWORD_HASH`). Nema default lozinke u seedu.

Otvori `/`, `/banke`, `/banka/raiffeisen`, `/uporedi`, `/kalkulator`, `/admin`.

## Šta namerno nije u v1 podacima

- mesečne naknade
- kamate
- EKS
- broj poslovnica i bankomata
- da li banka ima Apple Pay / Google Pay
- aktuelne promocije

Sve to čeka izvor + `verified_at`. Stranica banke ostaje živa i bez toga.

## Licence

Izvorni kod: MIT.

Tekst NBS registra je javni regulatorni podatak; portal ga ne prepakuje kao svoju tarifu.
