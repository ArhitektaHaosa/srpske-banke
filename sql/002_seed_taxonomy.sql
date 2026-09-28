SET NAMES utf8mb4;

INSERT INTO sources (id, slug, title, institution, source_type, tier, url, published_at) VALUES
(1, 'nbs-spisak-banaka', 'NBS — Spisak banaka', 'Narodna banka Srbije', 'nbs', 1, 'https://www.nbs.rs/sr_RS/finansijske-institucije/banke/spisak-banaka', NULL),
(2, 'nbs-bilans-2026-06-30', 'NBS — Bilans stanja/uspeha banaka na dan 30.6.2026.', 'Narodna banka Srbije', 'nbs', 1, 'https://nbs.rs/sr/finansijske-institucije/banke/bilans-stanja', '2026-06-30'),
(3, 'nbs-rtgs-bic-2026-09-01', 'NBS — Pregled brojeva računa i BIC, 1.9.2026.', 'Narodna banka Srbije', 'nbs', 1, 'https://www.nbs.rs/documents/platni-sistem/pregled_racuna_banka.pdf', '2026-09-01'),
(4, 'nbs-pputarifa', 'NBS — Uporedni pregled reprezentativnih naknada', 'Narodna banka Srbije', 'nbs', 1, 'https://pputarifa.nbs.rs', NULL),
(5, 'nbs-ips', 'NBS — IPS NBS', 'Narodna banka Srbije', 'nbs', 1, 'https://ips.nbs.rs', NULL);

INSERT INTO admin_roles (id, slug, name) VALUES
(1, 'super_admin', 'Super admin'),
(2, 'editor', 'Editor'),
(3, 'bank_editor', 'Bank editor'),
(4, 'reviewer', 'Reviewer');

INSERT INTO stale_thresholds (data_kind, days) VALUES
('promotion', 1),('account_fee', 7),('loan_rate', 7),('digital_feature', 30),('legal_bank', 90);

INSERT INTO product_types (id, slug, name, category) VALUES
(1,'basic-payment-account','Platni račun sa osnovnim uslugama','account'),
(2,'standard-account','Standardni račun','account'),
(3,'digital-account','Digitalni račun','account'),
(4,'premium-account','Premium račun','account'),
(5,'youth-account','Račun za mlade','account'),
(6,'student-account','Studentski račun','account'),
(7,'pensioner-account','Penzionerski račun','account'),
(8,'fx-account','Devizni račun','account'),
(9,'other-account','Ostali paketi','account'),
(10,'debit-card','Debitna kartica','card'),
(11,'credit-card','Kreditna kartica','card'),
(12,'prepaid-card','Prepaid kartica','card'),
(13,'cash-loan','Gotovinski kredit','loan'),
(14,'consumer-loan','Potrošački kredit','loan'),
(15,'refinancing-loan','Refinansirajući kredit','loan'),
(16,'housing-loan','Stambeni kredit','loan'),
(17,'auto-loan','Auto kredit','loan'),
(18,'pensioner-loan','Penzionerski kredit','loan'),
(19,'overdraft','Dozvoljeni minus','loan'),
(20,'savings-sight','Štednja po viđenju','savings'),
(21,'savings-term','Oročena štednja','savings'),
(22,'business-account','Poslovni račun','business');

INSERT INTO product_audiences (id, slug, name) VALUES
(1,'retail','Građani'),(2,'youth','Mladi'),(3,'student','Studenti'),(4,'pensioner','Penzioneri'),(5,'entrepreneur','Preduzetnici'),(6,'micro','Mikro firme'),(7,'legal','Pravna lica');

INSERT INTO fee_types (id, slug, name, category) VALUES
(1,'account-maintenance','Održavanje računa','account'),
(2,'account-open','Otvaranje računa','account'),
(3,'account-close','Zatvaranje računa','account'),
(4,'transfer-internal','Transfer unutar banke','payment'),
(5,'transfer-domestic-other','Transfer drugoj banci','payment'),
(6,'transfer-branch','Nalog na šalteru','payment'),
(7,'transfer-instant','Instant plaćanje','payment'),
(8,'ips-qr-scan','IPS QR scan','ips'),
(9,'ips-qr-show','IPS QR show','ips'),
(10,'transfer-phone','Prenos na broj telefona','ips'),
(11,'atm-own','Podizanje na sopstvenom ATM','card'),
(12,'atm-other','Podizanje na ATM druge banke','card'),
(13,'atm-abroad','Podizanje u inostranstvu','card'),
(14,'swift-out','SWIFT odlazni','payment'),
(15,'sepa-out','SEPA odlazni','payment'),
(16,'incoming-fx','Priliv iz inostranstva','payment');
