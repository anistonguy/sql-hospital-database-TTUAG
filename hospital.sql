-- ============================================================
-- Hospital Database Management System
-- Schema reconstructed to match hospital-db-erd.png
-- Author: Aniston Guy
-- Engine: InnoDB | Charset: utf8mb3
-- ============================================================

CREATE DATABASE IF NOT EXISTS `hospital` DEFAULT CHARACTER SET utf8mb3;
USE `hospital`;

-- ------------------------------------------------------------
-- Table: specialty
-- Physician specialties (e.g. Cardiology, Pediatrics)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `specialty`;
CREATE TABLE `specialty` (
  `ID` int NOT NULL,
  `PhysSpecialty` char(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: physician
-- Physician demographic info, linked to a specialty
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `physician`;
CREATE TABLE `physician` (
  `ID` int NOT NULL,
  `LastName` char(45) NOT NULL,
  `FirstName` char(45) NOT NULL,
  `Address1` char(45) DEFAULT NULL,
  `Address2` char(45) DEFAULT NULL,
  `City` char(45) DEFAULT NULL,
  `State` char(2) DEFAULT NULL,
  `ZipCode` char(10) DEFAULT NULL,
  `Phone` char(15) DEFAULT NULL,
  `specialty_ID` int NOT NULL,
  PRIMARY KEY (`ID`,`specialty_ID`),
  KEY `fk_physician_specialty1_idx` (`specialty_ID`),
  CONSTRAINT `fk_physician_specialty1` FOREIGN KEY (`specialty_ID`) REFERENCES `specialty` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: patient
-- Patient demographic and contact information
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `ID` int NOT NULL,
  `LastName` char(45) NOT NULL,
  `FirstName` char(45) NOT NULL,
  `Address1` char(45) DEFAULT NULL,
  `Address2` char(45) DEFAULT NULL,
  `City` char(45) DEFAULT NULL,
  `State` char(2) DEFAULT NULL,
  `ZipCode` char(10) DEFAULT NULL,
  `Phone` char(15) DEFAULT NULL,
  `Patient ID` char(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: admission
-- Tracks a patient's hospital stay (admit/release date, room)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `admission`;
CREATE TABLE `admission` (
  `ID` int NOT NULL,
  `AdmiDate` date NOT NULL,
  `ReleaseDATE` date DEFAULT NULL,
  `Room` char(45) DEFAULT NULL,
  `patient_ID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_admission_patient_idx` (`patient_ID`),
  CONSTRAINT `fk_admission_patient` FOREIGN KEY (`patient_ID`) REFERENCES `patient` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: diagnosis
-- Diagnosis types and associated symptoms
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `diagnosis`;
CREATE TABLE `diagnosis` (
  `ID` int NOT NULL,
  `DiagnosisType` char(45) NOT NULL,
  `Symptoms` char(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: procedure
-- Medical procedures, including cost and order date
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `procedure`;
CREATE TABLE `procedure` (
  `ID` int NOT NULL,
  `Procedure` char(45) NOT NULL,
  `DateOrdered` char(45) NOT NULL,
  `Cost` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: diagnosis_physician_admission
-- Junction table: links a diagnosis, the treating physician,
-- and the related admission
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `diagnosis_physician_admission`;
CREATE TABLE `diagnosis_physician_admission` (
  `ID` int NOT NULL,
  `diagnosis_ID` int NOT NULL,
  `physician_ID` int NOT NULL,
  `admission_ID` int NOT NULL,
  `DiagnosisDate` char(45) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_diagnosis_physician_admission_physician1_idx` (`physician_ID`),
  KEY `fk_diagnosis_physician_admission_diagnosis1_idx` (`diagnosis_ID`),
  KEY `fk_diagnosis_physician_admission_admission1_idx` (`admission_ID`),
  CONSTRAINT `fk_diagnosis_physician_admission_admission1` FOREIGN KEY (`admission_ID`) REFERENCES `admission` (`ID`),
  CONSTRAINT `fk_diagnosis_physician_admission_diagnosis1` FOREIGN KEY (`diagnosis_ID`) REFERENCES `diagnosis` (`ID`),
  CONSTRAINT `fk_diagnosis_physician_admission_physician1` FOREIGN KEY (`physician_ID`) REFERENCES `physician` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: physician_procedure
-- Junction table: which physicians perform which procedures
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `physician_procedure`;
CREATE TABLE `physician_procedure` (
  `physician_ID` int NOT NULL,
  `physician_specialty_ID` int NOT NULL,
  `procedure_ID` int NOT NULL,
  PRIMARY KEY (`physician_ID`,`physician_specialty_ID`,`procedure_ID`),
  KEY `fk_physician_procedure_procedure1_idx` (`procedure_ID`),
  CONSTRAINT `fk_physician_procedure_physician1` FOREIGN KEY (`physician_ID`, `physician_specialty_ID`) REFERENCES `physician` (`ID`, `specialty_ID`),
  CONSTRAINT `fk_physician_procedure_procedure1` FOREIGN KEY (`procedure_ID`) REFERENCES `procedure` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: diagnosis_physician_procedure
-- Junction table: which procedures were used to treat a
-- given diagnosis/physician/admission case
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `diagnosis_physician_procedure`;
CREATE TABLE `diagnosis_physician_procedure` (
  `diagnosis_physician_ID` int NOT NULL,
  `procedure_ID` int NOT NULL,
  PRIMARY KEY (`diagnosis_physician_ID`,`procedure_ID`),
  KEY `fk_dpp_procedure1_idx` (`procedure_ID`),
  CONSTRAINT `fk_dpp_diagnosis_physician_admission1` FOREIGN KEY (`diagnosis_physician_ID`) REFERENCES `diagnosis_physician_admission` (`ID`),
  CONSTRAINT `fk_dpp_procedure1` FOREIGN KEY (`procedure_ID`) REFERENCES `procedure` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ------------------------------------------------------------
-- Table: patient_care_team
-- Links patients to their assigned physician(s)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `patient_care_team`;
CREATE TABLE `patient_care_team` (
  `ID` int NOT NULL,
  `patient_ID` int NOT NULL,
  `physician_ID` int NOT NULL,
  `physician_specialty_ID` int NOT NULL,
  `PrimaryPhys` char(45) DEFAULT NULL,
  PRIMARY KEY (`ID`,`patient_ID`,`physician_ID`),
  KEY `fk_patient_care_team_patient1_idx` (`patient_ID`),
  KEY `fk_patient_care_team_physician1_idx` (`physician_ID`,`physician_specialty_ID`),
  CONSTRAINT `fk_patient_care_team_patient1` FOREIGN KEY (`patient_ID`) REFERENCES `patient` (`ID`),
  CONSTRAINT `fk_patient_care_team_physician1` FOREIGN KEY (`physician_ID`, `physician_specialty_ID`) REFERENCES `physician` (`ID`, `specialty_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
