-- Validates that a project category is valid for the given financing source.
CREATE FUNCTION check_project_category (
    financing_source_id INTEGER,
    project_category_id INTEGER
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
    BEGIN
        IF (financing_source_id <> 3) THEN
            RETURN TRUE;
        END IF;

        RETURN project_category_id IS NOT NULL;
    END;
$$;

-- This trigger function updates the `created_by_user_id` column based on
-- the user performing the insertion.
CREATE FUNCTION set_created_by_user_id () RETURNS TRIGGER LANGUAGE plpgsql AS $$
    BEGIN
        NEW.created_by_user_id := (SELECT id FROM users WHERE name = current_user);

        RETURN NEW;
    END;
$$;

-- Allocates a registration number for new expenditures.
CREATE FUNCTION allocate_expenditure_number () RETURNS TRIGGER LANGUAGE plpgsql AS $$
    BEGIN
        NEW.year := (SELECT last_value FROM years_sequence);
        -- RAISE NOTICE 'Year is %', NEW.year;

        NEW.number := (
            SELECT COALESCE(MAX(number), 0) + 1
            FROM expenditures
            WHERE year = NEW.year
        );
        -- RAISE NOTICE 'Number is %', NEW.number;

        RETURN NEW;
    END;
$$;

-- Allocates a registration number for new commitments.
CREATE FUNCTION allocate_commitment_number () RETURNS TRIGGER LANGUAGE plpgsql AS $$
    BEGIN
        NEW.year := (SELECT last_value FROM years_sequence);
        -- RAISE NOTICE 'Year is %', NEW.year;

        NEW.number := (
            SELECT COALESCE(MAX(number), 0) + 1
            FROM commitments
            WHERE year = NEW.year
        );
        -- RAISE NOTICE 'Number is %', NEW.number;

        RETURN NEW;
    END;
$$;
