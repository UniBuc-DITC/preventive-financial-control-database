-- Run the following code to get a list of all configured grants:
SELECT
    grantee,
    privilege_type,
    table_name
FROM
    information_schema.role_table_grants
WHERE
    grantee IN ('employee', 'supervisor')
ORDER BY
    grantee,
    privilege_type;

-- Employee permissions
GRANT
SELECT
    ON users TO employee;

GRANT
SELECT
    ON current_year TO employee;

GRANT
SELECT
    ON financing_sources TO employee;

GRANT
SELECT
    ON project_categories TO employee;

GRANT
SELECT
    ON expenditure_articles TO employee;

GRANT
SELECT
    ON payment_methods TO employee;

GRANT
SELECT
    ON expenditures TO employee;

GRANT INSERT ON expenditures TO employee;

-- Supervisor permissions
GRANT INSERT ON financing_sources TO supervisor;

GRANT INSERT ON project_categories TO supervisor;

GRANT INSERT ON expenditure_articles TO supervisor;

GRANT INSERT ON payment_methods TO supervisor;

GRANT
UPDATE ON financing_sources TO supervisor;

GRANT
UPDATE ON project_categories TO supervisor;

GRANT
UPDATE ON expenditure_articles TO supervisor;

GRANT
UPDATE ON payment_methods TO supervisor;

GRANT
UPDATE ON current_year TO supervisor;
