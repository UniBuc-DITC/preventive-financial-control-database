-- Trigger function for setting ID of row author
CREATE
OR REPLACE FUNCTION set_created_by_user_id () RETURNS TRIGGER LANGUAGE plpgsql AS $$
    BEGIN
        NEW.created_by_user_id := (SELECT id FROM users WHERE name = current_user);

        RETURN NEW;
    END;
$$;

CREATE TRIGGER set_created_by_user_id BEFORE INSERT ON expenditures FOR EACH ROW
EXECUTE FUNCTION set_created_by_user_id ();
