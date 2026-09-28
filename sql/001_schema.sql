-- srpske-banke schema. NULL is unknown. Never coerce NULL to 0.
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS sources (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(80) NOT NULL UNIQUE,
  title VARCHAR(255) NOT NULL,
  institution VARCHAR(255) NULL,
  source_type ENUM('nbs','bank_official','register','card_scheme','media','community','other') NOT NULL DEFAULT 'other',
  tier TINYINT UNSIGNED NOT NULL DEFAULT 4,
  url TEXT NULL,
  published_at DATE NULL,
  notes TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS banks (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(80) NOT NULL UNIQUE,
  brand_name VARCHAR(160) NOT NULL,
  legal_name VARCHAR(255) NOT NULL,
  status ENUM('active','inactive','merged','licence_revoked') NOT NULL DEFAULT 'active',
  nbs_participant_no SMALLINT UNSIGNED NULL,
  nbs_account VARCHAR(32) NULL,
  registration_number VARCHAR(20) NULL UNIQUE,
  swift_bic VARCHAR(11) NULL,
  headquarters_city VARCHAR(80) NULL,
  headquarters_address VARCHAR(255) NULL,
  website VARCHAR(255) NULL,
  call_center VARCHAR(80) NULL,
  phone VARCHAR(120) NULL,
  online_account_opening TINYINT(1) NULL,
  video_identification TINYINT(1) NULL,
  branch_count INT UNSIGNED NULL,
  atm_count INT UNSIGNED NULL,
  serves_retail TINYINT(1) NULL,
  serves_business TINYINT(1) NULL,
  last_verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  source_id BIGINT UNSIGNED NULL,
  merged_into_bank_id BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_banks_source FOREIGN KEY (source_id) REFERENCES sources(id),
  CONSTRAINT fk_banks_merged FOREIGN KEY (merged_into_bank_id) REFERENCES banks(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bank_aliases (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  alias VARCHAR(160) NOT NULL,
  alias_norm VARCHAR(160) NOT NULL,
  kind ENUM('brand','legal','short','typo','former','search') NOT NULL DEFAULT 'search',
  KEY ix_alias_norm (alias_norm),
  CONSTRAINT fk_alias_bank FOREIGN KEY (bank_id) REFERENCES banks(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bank_contacts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  kind ENUM('phone','call_center','email','address','other') NOT NULL,
  value VARCHAR(255) NOT NULL,
  source_id BIGINT UNSIGNED NULL,
  verified_at DATE NULL,
  CONSTRAINT fk_contacts_bank FOREIGN KEY (bank_id) REFERENCES banks(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bank_sources (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  source_id BIGINT UNSIGNED NOT NULL,
  role VARCHAR(80) NULL,
  UNIQUE KEY uq_bank_source (bank_id, source_id),
  CONSTRAINT fk_bs_bank FOREIGN KEY (bank_id) REFERENCES banks(id) ON DELETE CASCADE,
  CONSTRAINT fk_bs_source FOREIGN KEY (source_id) REFERENCES sources(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_types (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(80) NOT NULL UNIQUE,
  name VARCHAR(160) NOT NULL,
  category ENUM('account','card','payment','loan','savings','digital','ips','other','business') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_audiences (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(80) NOT NULL UNIQUE,
  name VARCHAR(160) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS products (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  product_type_id SMALLINT UNSIGNED NOT NULL,
  audience_id SMALLINT UNSIGNED NULL,
  slug VARCHAR(120) NOT NULL,
  name VARCHAR(255) NOT NULL,
  is_basic_payment_account TINYINT(1) NOT NULL DEFAULT 0,
  currency CHAR(3) NOT NULL DEFAULT 'RSD',
  monthly_fee DECIMAL(14,4) NULL,
  opening_fee DECIMAL(14,4) NULL,
  closing_fee DECIMAL(14,4) NULL,
  promo_monthly_fee DECIMAL(14,4) NULL,
  included_summary TEXT NULL,
  included_transfers INT UNSIGNED NULL,
  inflow_required DECIMAL(14,4) NULL,
  min_age TINYINT UNSIGNED NULL,
  max_age TINYINT UNSIGNED NULL,
  free_maintenance_condition TEXT NULL,
  effective_from DATE NULL,
  effective_to DATE NULL,
  source_id BIGINT UNSIGNED NULL,
  source_url TEXT NULL,
  retrieved_at DATE NULL,
  verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  extra_json JSON NULL,
  UNIQUE KEY uq_product_bank_slug (bank_id, slug),
  CONSTRAINT fk_prod_bank FOREIGN KEY (bank_id) REFERENCES banks(id),
  CONSTRAINT fk_prod_type FOREIGN KEY (product_type_id) REFERENCES product_types(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS fee_types (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(80) NOT NULL UNIQUE,
  name VARCHAR(160) NOT NULL,
  category VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS fees (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NULL,
  fee_type_id SMALLINT UNSIGNED NOT NULL,
  label VARCHAR(255) NOT NULL,
  fixed_fee DECIMAL(14,4) NULL,
  percentage_fee DECIMAL(8,4) NULL,
  minimum_fee DECIMAL(14,4) NULL,
  maximum_fee DECIMAL(14,4) NULL,
  included_quantity INT UNSIGNED NULL,
  currency CHAR(3) NOT NULL DEFAULT 'RSD',
  channel ENUM('any','ebanking','mobile','branch','atm_own','atm_other','international','ips','phone') NOT NULL DEFAULT 'any',
  direction ENUM('domestic','international','any') NOT NULL DEFAULT 'domestic',
  counterparty ENUM('own_bank','other_bank','any') NOT NULL DEFAULT 'any',
  condition_text TEXT NULL,
  effective_from DATE NULL,
  effective_to DATE NULL,
  source_id BIGINT UNSIGNED NULL,
  source_url TEXT NULL,
  retrieved_at DATE NULL,
  verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  CONSTRAINT fk_fees_bank FOREIGN KEY (bank_id) REFERENCES banks(id),
  CONSTRAINT fk_fees_type FOREIGN KEY (fee_type_id) REFERENCES fee_types(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS features (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(80) NOT NULL UNIQUE,
  name VARCHAR(160) NOT NULL,
  group_name VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_features (
  product_id BIGINT UNSIGNED NOT NULL,
  feature_id SMALLINT UNSIGNED NOT NULL,
  value_text VARCHAR(255) NULL,
  available TINYINT(1) NULL,
  source_id BIGINT UNSIGNED NULL,
  verified_at DATE NULL,
  PRIMARY KEY (product_id, feature_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS interest_rates (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NULL,
  kind ENUM('loan','savings','overdraft','card') NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'RSD',
  nominal_rate DECIMAL(8,4) NULL,
  eks DECIMAL(8,4) NULL,
  rate_type ENUM('fixed','variable','combined') NULL,
  reference_index VARCHAR(40) NULL,
  amount_from DECIMAL(16,2) NULL,
  amount_to DECIMAL(16,2) NULL,
  term_from_months SMALLINT UNSIGNED NULL,
  term_to_months SMALLINT UNSIGNED NULL,
  processing_fee DECIMAL(14,4) NULL,
  insurance_required TINYINT(1) NULL,
  salary_transfer_required TINYINT(1) NULL,
  representative_example TEXT NULL,
  early_withdrawal_rule TEXT NULL,
  min_deposit DECIMAL(16,2) NULL,
  effective_from DATE NULL,
  effective_to DATE NULL,
  source_id BIGINT UNSIGNED NULL,
  source_url TEXT NULL,
  retrieved_at DATE NULL,
  verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  CONSTRAINT fk_ir_bank FOREIGN KEY (bank_id) REFERENCES banks(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS cards (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NULL,
  name VARCHAR(160) NOT NULL,
  card_kind ENUM('debit','credit','prepaid') NOT NULL,
  scheme ENUM('dina','visa','mastercard','other') NOT NULL,
  issuance_fee DECIMAL(14,4) NULL,
  maintenance_fee DECIMAL(14,4) NULL,
  replacement_fee DECIMAL(14,4) NULL,
  extra_card_fee DECIMAL(14,4) NULL,
  atm_own_fee DECIMAL(14,4) NULL,
  atm_other_fee DECIMAL(14,4) NULL,
  atm_abroad_fee DECIMAL(14,4) NULL,
  fx_markup_pct DECIMAL(8,4) NULL,
  contactless TINYINT(1) NULL,
  online_payments TINYINT(1) NULL,
  virtual_card TINYINT(1) NULL,
  apple_pay TINYINT(1) NULL,
  google_pay TINYINT(1) NULL,
  installments TINYINT(1) NULL,
  effective_from DATE NULL,
  effective_to DATE NULL,
  source_id BIGINT UNSIGNED NULL,
  source_url TEXT NULL,
  verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  CONSTRAINT fk_cards_bank FOREIGN KEY (bank_id) REFERENCES banks(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS card_features (
  card_id BIGINT UNSIGNED NOT NULL,
  feature_id SMALLINT UNSIGNED NOT NULL,
  available TINYINT(1) NULL,
  value_text VARCHAR(255) NULL,
  PRIMARY KEY (card_id, feature_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS digital_services (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL UNIQUE,
  web_banking TINYINT(1) NULL,
  mobile_banking TINYINT(1) NULL,
  android_app TINYINT(1) NULL,
  ios_app TINYINT(1) NULL,
  online_onboarding TINYINT(1) NULL,
  video_identification TINYINT(1) NULL,
  digital_signature TINYINT(1) NULL,
  push_notifications TINYINT(1) NULL,
  instant_payments TINYINT(1) NULL,
  card_controls TINYINT(1) NULL,
  temp_card_block TINYINT(1) NULL,
  limit_change TINYINT(1) NULL,
  virtual_cards TINYINT(1) NULL,
  wallets_note TEXT NULL,
  source_id BIGINT UNSIGNED NULL,
  verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS ips_services (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL UNIQUE,
  ips_scan TINYINT(1) NULL,
  ips_show TINYINT(1) NULL,
  transfer_by_phone TINYINT(1) NULL,
  instant_receive TINYINT(1) NULL,
  instant_send TINYINT(1) NULL,
  source_id BIGINT UNSIGNED NULL,
  verified_at DATE NULL,
  verification_status ENUM('VERIFIED','STALE','PENDING_REVIEW','SOURCE_CONFLICT','UNAVAILABLE') NOT NULL DEFAULT 'PENDING_REVIEW',
  is_published TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS promotions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  short_title VARCHAR(120) NULL,
  description TEXT NULL,
  terms TEXT NULL,
  eligibility TEXT NULL,
  cta_text VARCHAR(80) NULL,
  cta_url TEXT NULL,
  promo_code VARCHAR(80) NULL,
  regular_price DECIMAL(14,4) NULL,
  promo_price DECIMAL(14,4) NULL,
  currency CHAR(3) NOT NULL DEFAULT 'RSD',
  valid_from DATE NULL,
  valid_until DATE NULL,
  start_at DATETIME NULL,
  end_at DATETIME NULL,
  source_url TEXT NULL,
  source_id BIGINT UNSIGNED NULL,
  source_verified_at DATE NULL,
  is_enabled TINYINT(1) NOT NULL DEFAULT 0,
  is_featured TINYINT(1) NOT NULL DEFAULT 0,
  is_sponsored TINYINT(1) NOT NULL DEFAULT 0,
  is_affiliate TINYINT(1) NOT NULL DEFAULT 0,
  display_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_promo_bank FOREIGN KEY (bank_id) REFERENCES banks(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS source_snapshots (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  source_id BIGINT UNSIGNED NULL,
  bank_id BIGINT UNSIGNED NULL,
  url TEXT NOT NULL,
  http_status SMALLINT NULL,
  content_hash CHAR(64) NULL,
  raw_path VARCHAR(255) NULL,
  retrieved_at DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS imports (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  adapter VARCHAR(80) NOT NULL,
  started_at DATETIME NOT NULL,
  finished_at DATETIME NULL,
  status ENUM('running','completed','failed') NOT NULL DEFAULT 'running',
  note TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS import_changes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  import_id BIGINT UNSIGNED NOT NULL,
  bank_id BIGINT UNSIGNED NULL,
  entity_type VARCHAR(40) NOT NULL,
  entity_id BIGINT UNSIGNED NULL,
  field_name VARCHAR(80) NOT NULL,
  old_value TEXT NULL,
  new_value TEXT NULL,
  source_url TEXT NULL,
  review_status ENUM('pending','approved','rejected','edited','kept_old') NOT NULL DEFAULT 'pending',
  reviewed_by BIGINT UNSIGNED NULL,
  reviewed_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ic_import FOREIGN KEY (import_id) REFERENCES imports(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS data_conflicts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bank_id BIGINT UNSIGNED NULL,
  entity_type VARCHAR(40) NOT NULL,
  field_name VARCHAR(80) NOT NULL,
  value_a TEXT NULL,
  source_a_id BIGINT UNSIGNED NULL,
  value_b TEXT NULL,
  source_b_id BIGINT UNSIGNED NULL,
  status ENUM('open','resolved','superseded') NOT NULL DEFAULT 'open',
  public_message VARCHAR(255) NOT NULL DEFAULT 'Zvanicni izvori trenutno daju razlicite podatke. Provera u toku.',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS change_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  entity_type VARCHAR(40) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL,
  field_name VARCHAR(80) NOT NULL,
  old_value TEXT NULL,
  new_value TEXT NULL,
  effective_from DATE NULL,
  source_id BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY ix_hist_entity (entity_type, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS admin_roles (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(40) NOT NULL UNIQUE,
  name VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS admin_users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(120) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS admin_user_roles (
  user_id BIGINT UNSIGNED NOT NULL,
  role_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_aur_user FOREIGN KEY (user_id) REFERENCES admin_users(id) ON DELETE CASCADE,
  CONSTRAINT fk_aur_role FOREIGN KEY (role_id) REFERENCES admin_roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS admin_bank_permissions (
  user_id BIGINT UNSIGNED NOT NULL,
  bank_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (user_id, bank_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  action VARCHAR(80) NOT NULL,
  entity_type VARCHAR(40) NULL,
  entity_id BIGINT UNSIGNED NULL,
  old_value TEXT NULL,
  new_value TEXT NULL,
  reason VARCHAR(255) NULL,
  ip VARCHAR(45) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS stale_thresholds (
  data_kind VARCHAR(40) PRIMARY KEY,
  days INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
