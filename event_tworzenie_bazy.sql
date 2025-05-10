-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema is_siehena
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema is_siehena
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `is_siehena` DEFAULT CHARACTER SET utf8 ;
USE `is_siehena` ;

-- -----------------------------------------------------
-- Table `is_siehena`.`db_event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_event` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_event` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nazwa` VARCHAR(45) NOT NULL,
  `termin` DATETIME NOT NULL,
  `miasto` VARCHAR(45) NULL,
  `kod_pocztowy` VARCHAR(45) NULL,
  `ulica` VARCHAR(45) NULL,
  `nr_budynku` VARCHAR(45) NULL,
  `nr_lokalu` VARCHAR(45) NULL,
  `państwo` VARCHAR(45) NULL,
  `województwo` VARCHAR(45) NULL,
  `kontrahent_id` INT NOT NULL,
  `kwota_netto` DECIMAL(10,2) NULL,
  `stawka_vat` DECIMAL(5,2) NULL,
  `kwota_brutto` DECIMAL(10,2) NULL,
  `status` SET('planowany', 'zakonczony', 'odwolany') NULL,
  `data_odwolania` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_kontrahent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_kontrahent` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_kontrahent` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nazwa` VARCHAR(45) NOT NULL,
  `typ_kontrahenta` SET('firma', 'osoba fizyczna') NOT NULL,
  `NIP` VARCHAR(12) NULL,
  `miasto` VARCHAR(45) NULL,
  `ulica` VARCHAR(45) NULL,
  `nr_budynku` VARCHAR(10) NULL,
  `nr_lokalu` VARCHAR(10) NULL,
  `kod_pocztowy` VARCHAR(6) NULL,
  `opis` TEXT NULL,
  `państwo` VARCHAR(45) NULL,
  `województwo` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_dzial`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_dzial` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_dzial` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nazwa_dzialu` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_pracownik`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_pracownik` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_pracownik` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `imie` VARCHAR(45) NOT NULL,
  `nazwisko` VARCHAR(45) NOT NULL,
  `dzial_id` INT NOT NULL,
  `nr_konta_bankowego` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_pracownik_dzial1_idx` (`dzial_id` ASC) VISIBLE,
  CONSTRAINT `fk_pracownik_dzial1`
    FOREIGN KEY (`dzial_id`)
    REFERENCES `is_siehena`.`db_dzial` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_dokument_finansowy_naglowek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_dokument_finansowy_naglowek` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_dokument_finansowy_naglowek` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dokument_finansowycol` VARCHAR(45) NULL,
  `data_wydruku` VARCHAR(45) NULL,
  `typ_dokumentu` SET('paragon', 'faktura') NULL,
  `typ_transakcji` SET('zakup', 'sprzedaz') NULL,
  `dokument_finansowy_naglowekcol` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_pensje`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_pensje` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_pensje` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `netto` DECIMAL(10,2) NULL,
  `składki` DECIMAL(10,2) NULL,
  `do_przelewu` DECIMAL(10,2) NULL,
  `data` DATE NULL,
  `status` SET('oczekuje', 'komornik', 'przelane') NULL,
  `pensjecol` VARCHAR(45) NULL,
  `pracownik_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pensje_pracownik1_idx` (`pracownik_id` ASC) VISIBLE,
  CONSTRAINT `fk_pensje_pracownik1`
    FOREIGN KEY (`pracownik_id`)
    REFERENCES `is_siehena`.`db_pracownik` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_rozliczenie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_rozliczenie` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_rozliczenie` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `typ` SET('przychod', 'koszt') NOT NULL,
  `status` SET('rozliczone', 'nierozliczone') NOT NULL DEFAULT 'nierozliczone',
  `data` DATE NOT NULL,
  `dokument_finansowy_naglowek_id` INT NOT NULL,
  `pensje_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_rozliczenie_dokument_finansowy_naglowek1_idx` (`dokument_finansowy_naglowek_id` ASC) VISIBLE,
  INDEX `fk_rozliczenie_pensje1_idx` (`pensje_id` ASC) VISIBLE,
  INDEX `fk_rozliczenie_event1_idx` (`event_id` ASC) VISIBLE,
  CONSTRAINT `fk_rozliczenie_dokument_finansowy_naglowek1`
    FOREIGN KEY (`dokument_finansowy_naglowek_id`)
    REFERENCES `is_siehena`.`db_dokument_finansowy_naglowek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rozliczenie_pensje1`
    FOREIGN KEY (`pensje_id`)
    REFERENCES `is_siehena`.`db_pensje` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rozliczenie_event1`
    FOREIGN KEY (`event_id`)
    REFERENCES `is_siehena`.`db_event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_dokument_finansowy_wiersz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_dokument_finansowy_wiersz` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_dokument_finansowy_wiersz` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dokument_finansowy_naglowek_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_dokument_finansowy_wiersz_dokument_finansowy_naglowek1_idx` (`dokument_finansowy_naglowek_id` ASC) VISIBLE,
  INDEX `fk_dokument_finansowy_wiersz_event1_idx` (`event_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_dokument_finansowy_wiersz_dokument_finansowy_naglowek1`
    FOREIGN KEY (`dokument_finansowy_naglowek_id`)
    REFERENCES `is_siehena`.`db_dokument_finansowy_naglowek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dokument_finansowy_wiersz_event1`
    FOREIGN KEY (`event_id`)
    REFERENCES `is_siehena`.`db_event` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `is_siehena`.`db_kontrahent_has_dokument_finansowy_naglowek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `is_siehena`.`db_kontrahent_has_dokument_finansowy_naglowek` ;

CREATE TABLE IF NOT EXISTS `is_siehena`.`db_kontrahent_has_dokument_finansowy_naglowek` (
  `kontrahent_id` INT NOT NULL,
  `dokument_finansowy_naglowek_id` INT NOT NULL,
  PRIMARY KEY (`kontrahent_id`, `dokument_finansowy_naglowek_id`),
  INDEX `fk_kontrahent_has_dokument_finansowy_naglowek_dokument_fina_idx` (`dokument_finansowy_naglowek_id` ASC) VISIBLE,
  INDEX `fk_kontrahent_has_dokument_finansowy_naglowek_kontrahent1_idx` (`kontrahent_id` ASC) VISIBLE,
  CONSTRAINT `fk_kontrahent_has_dokument_finansowy_naglowek_kontrahent1`
    FOREIGN KEY (`kontrahent_id`)
    REFERENCES `is_siehena`.`db_kontrahent` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_kontrahent_has_dokument_finansowy_naglowek_dokument_finans1`
    FOREIGN KEY (`dokument_finansowy_naglowek_id`)
    REFERENCES `is_siehena`.`db_dokument_finansowy_naglowek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
