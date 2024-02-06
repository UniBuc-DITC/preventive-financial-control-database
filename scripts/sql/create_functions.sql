-- Validates that a project category is valid for the given financing source.
CREATE FUNCTION check_project_category (
    financing_source_id INTEGER,
    project_category_id INTEGER
) RETURNS BOOLEAN
SET
    search_path = public LANGUAGE plpgsql AS $$
    DECLARE
        research_financing_source_id integer;
    BEGIN
        research_financing_source_id := (
            SELECT id
            FROM financing_sources
            WHERE name = 'Cercetare'
        );

        IF financing_source_id = research_financing_source_id THEN
            -- Project category must be set when financing source is "research"
            RETURN project_category_id IS NOT NULL;
        END IF;

        -- Otherwise, it must not be set
        RETURN project_category_id IS NULL;
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

ALTER FUNCTION set_created_by_user_id () OWNER TO ADMIN;

-- Allocates a registration number for new expenditures.
CREATE FUNCTION allocate_expenditure_number () RETURNS TRIGGER SECURITY DEFINER
SET
    search_path = public LANGUAGE plpgsql AS $$
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
CREATE FUNCTION allocate_commitment_number () RETURNS TRIGGER SECURITY DEFINER
SET
    search_path = public LANGUAGE plpgsql AS $$
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

ALTER FUNCTION allocate_commitment_number () OWNER TO ADMIN;

-- Function to log activity upon performing insertion/update/deletion on table.
CREATE FUNCTION log_activity () RETURNS TRIGGER LANGUAGE plpgsql AS $$
    DECLARE
        current_user_id integer;
        action_id integer;
        target_table_id integer;
        target_object_id text;
    BEGIN
        current_user_id := (SELECT id FROM public.users WHERE name = CURRENT_USER);
        IF current_user_id IS NULL THEN
            RAISE EXCEPTION 'User not found: %', CURRENT_USER
                USING HINT = 'Please make sure user has been previously registered';
        END IF;

        action_id := (SELECT id FROM audit.actions WHERE name = TG_OP);
        target_table_id := (SELECT id FROM audit.tables WHERE name = TG_TABLE_NAME);

        IF TG_OP = 'INSERT'
        THEN
            IF TG_TABLE_NAME IN ('expenditures', 'commitments')
            THEN
                target_object_id := CONCAT(NEW.number, '/', NEW.year);
            ELSE
                target_object_id := NEW.id::text;
            END IF;
        ELSE
            IF TG_TABLE_NAME IN ('expenditures', 'commitments')
            THEN
                target_object_id := CONCAT(OLD.number, '/', OLD.year);
            ELSE
                target_object_id := OLD.id::text;
            END IF;
        END IF;

        INSERT INTO audit.activity_log (
            timestamp, user_id, action_id,
            target_table_id, target_object_id
        )
        VALUES (
            CURRENT_TIMESTAMP, current_user_id, action_id,
            target_table_id, target_object_id
        );

        RETURN NULL;
    END;
$$;

ALTER FUNCTION log_activity () OWNER TO ADMIN;
