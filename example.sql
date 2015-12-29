DROP TABLE IF EXISTS phones;

CREATE TABLE phones (
  id        SERIAL PRIMARY KEY,
  ph_number VARCHAR(255)
);

INSERT INTO phones (ph_number) VALUES ('508-951-2054'), ('+19786601233'), ('+46 734 345 543'), ('333');

SELECT
  id,
  ph_number,
  extract_code_and_number(ph_number)
FROM phones;