-- Retrieve current year to be used for new expenditures.
SELECT last_value FROM years_sequence;

-- Sequence of code to convert from `serial` to `identity`
BEGIN;

ALTER TABLE financing_sources ALTER id DROP DEFAULT; -- drop default

DROP SEQUENCE financing_sources_id_seq;              -- drop owned sequence

ALTER TABLE financing_sources
    ALTER id SET DATA TYPE int,                   -- not needed: already int
    ALTER id ADD GENERATED ALWAYS AS IDENTITY (RESTART 0);

COMMIT;
