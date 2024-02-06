CREATE TRIGGER set_created_by_user_id BEFORE INSERT ON expenditures FOR EACH ROW
EXECUTE FUNCTION set_created_by_user_id ();

CREATE TRIGGER allocate_expenditure_number BEFORE INSERT ON expenditures FOR EACH ROW
EXECUTE PROCEDURE allocate_expenditure_number ();

CREATE TRIGGER set_created_by_user_id BEFORE INSERT ON commitments FOR EACH ROW
EXECUTE FUNCTION set_created_by_user_id ();

CREATE TRIGGER allocate_commitment_number BEFORE INSERT ON commitments FOR EACH ROW
EXECUTE PROCEDURE allocate_commitment_number ();

-- Activity logging triggers
DROP TRIGGER log_activity ON commitments;

DROP TRIGGER log_activity ON expenditure_articles;

DROP TRIGGER log_activity ON expenditures;

DROP TRIGGER log_activity ON financing_sources;

DROP TRIGGER log_activity ON payment_methods;

DROP TRIGGER log_activity ON project_categories;

CREATE
OR REPLACE TRIGGER log_activity
AFTER INSERT
OR
UPDATE
OR DELETE ON commitments FOR EACH ROW
EXECUTE FUNCTION log_activity ();

CREATE
OR REPLACE TRIGGER log_activity
AFTER INSERT
OR
UPDATE
OR DELETE ON expenditure_articles FOR EACH ROW
EXECUTE FUNCTION log_activity ();

CREATE
OR REPLACE TRIGGER log_activity
AFTER INSERT
OR
UPDATE
OR DELETE ON expenditures FOR EACH ROW
EXECUTE FUNCTION log_activity ();

CREATE
OR REPLACE TRIGGER log_activity
AFTER INSERT
OR
UPDATE
OR DELETE ON financing_sources FOR EACH ROW
EXECUTE FUNCTION log_activity ();

CREATE
OR REPLACE TRIGGER log_activity
AFTER INSERT
OR
UPDATE
OR DELETE ON payment_methods FOR EACH ROW
EXECUTE FUNCTION log_activity ();

CREATE
OR REPLACE TRIGGER log_activity
AFTER INSERT
OR
UPDATE
OR DELETE ON project_categories FOR EACH ROW
EXECUTE FUNCTION log_activity ();
