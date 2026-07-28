-- ============================================================
-- Hospital Database — Sample Queries
-- Demonstration queries written against hospital.sql
-- ============================================================

-- 1. List all procedures performed for a given patient,
--    including which physician ordered them and the cost.
SELECT
    p.FirstName AS PatientFirstName,
    p.LastName  AS PatientLastName,
    pr.Procedure,
    pr.DateOrdered,
    pr.Cost,
    ph.FirstName AS PhysicianFirstName,
    ph.LastName  AS PhysicianLastName
FROM patient p
JOIN admission a
    ON a.patient_ID = p.ID
JOIN diagnosis_physician_admission dpa
    ON dpa.admission_ID = a.ID
JOIN diagnosis_physician_procedure dpp
    ON dpp.diagnosis_physician_ID = dpa.ID
JOIN procedure pr
    ON pr.ID = dpp.procedure_ID
JOIN physician ph
    ON ph.ID = dpa.physician_ID
WHERE p.ID = 1;

-- 2. List all physicians grouped by their specialty.
SELECT
    s.PhysSpecialty,
    ph.FirstName,
    ph.LastName
FROM physician ph
JOIN specialty s
    ON s.ID = ph.specialty_ID
ORDER BY s.PhysSpecialty, ph.LastName;

-- 3. Get a patient's full care team (all assigned physicians
--    and their specialties), flagging the primary physician.
SELECT
    p.FirstName AS PatientFirstName,
    p.LastName  AS PatientLastName,
    ph.FirstName AS PhysicianFirstName,
    ph.LastName  AS PhysicianLastName,
    s.PhysSpecialty,
    pct.PrimaryPhys
FROM patient_care_team pct
JOIN patient p
    ON p.ID = pct.patient_ID
JOIN physician ph
    ON ph.ID = pct.physician_ID AND ph.specialty_ID = pct.physician_specialty_ID
JOIN specialty s
    ON s.ID = ph.specialty_ID
WHERE p.ID = 1;

-- 4. Total procedure cost billed per admission.
SELECT
    a.ID AS AdmissionID,
    a.AdmiDate,
    a.ReleaseDATE,
    SUM(pr.Cost) AS TotalProcedureCost
FROM admission a
JOIN diagnosis_physician_admission dpa
    ON dpa.admission_ID = a.ID
JOIN diagnosis_physician_procedure dpp
    ON dpp.diagnosis_physician_ID = dpa.ID
JOIN procedure pr
    ON pr.ID = dpp.procedure_ID
GROUP BY a.ID, a.AdmiDate, a.ReleaseDATE;
