SET NAMES utf8mb4;

-- NBS RTGS/BIC 1.9.2026 + NBS list + NBS balance 30.6.2026
-- Euroclear is RTGS participant, not a Serbian commercial bank.

INSERT INTO banks (
  id, slug, brand_name, legal_name, status,
  nbs_participant_no, nbs_account, registration_number, swift_bic,
  headquarters_city, headquarters_address, phone,
  last_verified_at, verification_status, source_id
) VALUES
(1,  'aikbank',        'AIK Bank',                   'AIKBANK AKCIONARSKO DRUSTVO, BEOGRAD',                  'active',  1, '908-10501-97', '06876366', 'AIKBRS22XXX', 'Beograd',  'Bulevar Arsenija Carnojevica 59a, Beograd',             '0800-10-10-15',     '2026-09-01', 'VERIFIED', 3),
(2,  'yettel',         'Yettel Bank',                'YETTEL BANK AD BEOGRAD',                                 'active',  2, '908-11501-07', '17138669', 'AAAARSBGXXX', 'Beograd',  'Omladinskih brigada 88, Beograd',                       '011/4409-670',      '2026-09-01', 'VERIFIED', 3),
(3,  'adriatic',       'Adriatic Bank',              'ADRIATIC BANK AKCIONARSKO DRUSTVO BEOGRAD',              'active',  3, '908-14501-28', '07534183', 'LIKIRSBGXXX', 'Beograd',  'Dalmatinska 22, Beograd',                               '011/3306-300',      '2026-09-01', 'VERIFIED', 3),
(4,  'halkbank',       'Halkbank',                   'HALKBANK AKCIONARSKO DRUSTVO BEOGRAD',                   'active',  4, '908-15501-35', '07601093', 'CABARS22XXX', 'Beograd',  'Milutina Milankovica 9e, Beograd',                      '011/2041-800',      '2026-09-01', 'VERIFIED', 3),
(5,  'banca-intesa',   'Banca Intesa',               'BANCA INTESA AKCIONARSKO DRUSTVO BEOGRAD',               'active',  5, '908-16001-87', '07759231', 'DBDBRSBGXXX', 'Beograd',  'Milentija Popovica 7b, Beograd',                        '011/2011-200',      '2026-09-01', 'VERIFIED', 3),
(6,  'addiko',         'Addiko Bank',                'ADDIKO BANK AD BEOGRAD',                                 'active',  6, '908-16501-42', '07726716', 'HAABRSBGXXX', 'Beograd',  'Omladinskih brigada 90G, Beograd',                      '+381 11 22 26 000', '2026-09-01', 'VERIFIED', 3),
(7,  'unicredit',      'UniCredit Bank Srbija',      'UNICREDIT BANK SRBIJA A.D. BEOGRAD',                      'active',  7, '908-17001-94', '17324918', 'BACXRSBGXXX', 'Beograd',  'Rajiceva 27-29, Beograd',                               '011/3777-888',      '2026-09-01', 'VERIFIED', 3),
(8,  'alta',           'Alta banka',                 'ALTA BANKA A.D. BEOGRAD',                                'active',  8, '908-19001-11', '07074433', 'JMBNRSBGXXX', 'Beograd',  'Bulevar Zorana Djindjica 121, Beograd',                 '011/2205-500',      '2026-09-01', 'VERIFIED', 3),
(9,  'postanska',      'Banka Postanska stedionica', 'BANKA POSTANSKA STEDIONICA AKCIONARSKO DRUSTVO BEOGRAD',  'active',  9, '908-20001-18', '07004893', 'SBPORSBGXXX', 'Beograd',  'Kraljice Marije 3, Beograd',                            '011/2020-292',      '2026-09-01', 'VERIFIED', 3),
(10, 'nlb',            'NLB Banka',                  'NLB BANKA AD BEOGRAD',                                   'active', 10, '908-20501-70', '07737068', 'KOBBRSBGXXX', 'Beograd',  'Bulevar Mihajla Pupina 165V, Beograd',                  '011/20 18 600',     '2026-09-01', 'VERIFIED', 3),
(11, 'procredit',      'ProCredit Bank',             'PROCREDIT BANK A.D. BEOGRAD',                            'active', 11, '908-22001-32', '17335677', 'PRCBRSBGXXX', 'Beograd',  'Milutina Milankovica 17, Beograd',                      '011/205-7000',      '2026-09-01', 'VERIFIED', 3),
(12, 'raiffeisen',     'Raiffeisen banka',           'RAIFFEISEN BANKA A.D. BEOGRAD',                          'active', 12, '908-26501-15', '17335600', 'RZBSRSBGXXX', 'Beograd',  'Djordja Stanojevica 16, Beograd',                       '011/3202-100',      '2026-09-01', 'VERIFIED', 3),
(13, 'srpska-banka',   'Srpska banka',               'SRPSKA BANKA A.D. BEOGRAD',                              'active', 13, '908-29501-36', '07092288', 'SRBNRSBGXXX', 'Beograd',  'Bulevar Kralja Aleksandra I Karadjordjevica 25, Beograd','011/3607-200',     '2026-09-01', 'VERIFIED', 3),
(14, 'otp',            'OTP banka Srbija',           'OTP BANKA SRBIJA AKCIONARSKO DRUSTVO NOVI SAD',           'active', 14, '908-32501-57', '08603537', 'OTPVRS22XXX', 'Novi Sad', 'Trg slobode 5, Novi Sad',                               '021/4800001',       '2026-09-01', 'VERIFIED', 3),
(15, 'erste',          'Erste Bank',                 'ERSTE BANK AKCIONARSKO DRUSTVO NOVI SAD',                'active', 15, '908-34001-19', '08063818', 'GIBARS22XXX', 'Novi Sad', 'Industrijska 3J, Novi Sad',                             '0800/201-201',      '2026-09-01', 'VERIFIED', 3),
(16, '3banka',         '3 Banka',                    '3 BANKA A.D. NOVI SAD',                                  'active', 16, '908-37001-40', '08761132', 'OPPBRS22XXX', 'Novi Sad', 'Bulevar oslobodjenja 2a, Novi Sad',                     '021/530-111',       '2026-09-01', 'VERIFIED', 3),
(17, 'api-bank',       'API Bank',                   'API BANK A.D. BEOGRAD',                                  'active', 17, '908-37501-92', '20439866', 'APIBRSBGXXX', 'Beograd',  'Bulevar vojvode Bojovica 6-8, Beograd',                 '011/3952-213',      '2026-09-01', 'VERIFIED', 3),
(18, 'mirabank',       'Mirabank',                   'MIRABANK AKCIONARSKO DRUSTVO BEOGRAD',                   'active', 18, '908-38001-47', '21080608', 'MRBNRSBGXXX', 'Beograd',  'Spanskih boraca 1, Beograd',                            '011 63 55 400',     '2026-09-01', 'VERIFIED', 3),
(19, 'bank-of-china',  'Bank of China Srbija',       'BANK OF CHINA SRBIJA A.D. BEOGRAD - NOVI BEOGRAD',       'active', 19, '908-38501-02', '21251640', 'BKCHRSBGXXX', 'Beograd',  'Bulevar Zorana Djindjica 2a, Beograd',                  '011/6351-000',      '2026-09-01', 'VERIFIED', 3);

INSERT INTO bank_aliases (bank_id, alias, alias_norm, kind) VALUES
(1,'AIKBANK','aikbank','brand'),(1,'AIK Banka','aik banka','search'),
(2,'Yettel','yettel','brand'),(2,'Telenor banka','telenor banka','former'),(2,'Mobi Banka','mobi banka','former'),
(3,'Adriatic','adriatic','short'),
(4,'Halk banka','halk banka','search'),(4,'Cacanska banka','cacanska banka','former'),
(5,'Intesa','intesa','short'),(5,'Banca Intesa','banca intesa','brand'),
(6,'Addiko','addiko','brand'),(6,'Hypo','hypo','former'),
(7,'Unikredit','unikredit','typo'),(7,'UniCredit','unicredit','brand'),
(8,'Alta','alta','short'),(8,'Jubmes','jubmes','former'),
(9,'Postanska','postanska','short'),(9,'Postanska stedionica','postanska stedionica','search'),
(10,'NLB','nlb','short'),(10,'NLB Komercijalna banka','nlb komercijalna banka','former'),(10,'Komercijalna banka','komercijalna banka','former'),
(11,'ProCredit','procredit','brand'),
(12,'Raiffeisen','raiffeisen','brand'),(12,'Rajfajzen','rajfajzen','typo'),(12,'RF','rf','short'),
(13,'Srpska banka','srpska banka','brand'),
(14,'OTP','otp','short'),(14,'OTP banka','otp banka','search'),
(15,'Erste','erste','brand'),
(16,'3Banka','3banka','brand'),(16,'Opportunity','opportunity','former'),(16,'Direktna banka','direktna banka','former'),
(17,'API','api','short'),
(18,'Mirabank','mirabank','brand'),
(19,'Bank of China','bank of china','brand'),(19,'BOC','boc','short');

INSERT INTO bank_sources (bank_id, source_id, role) SELECT id, 3, 'rtgs-bic' FROM banks;
INSERT INTO bank_sources (bank_id, source_id, role) SELECT id, 1, 'nbs-list' FROM banks;
INSERT INTO bank_sources (bank_id, source_id, role) SELECT id, 2, 'nbs-balance' FROM banks;
