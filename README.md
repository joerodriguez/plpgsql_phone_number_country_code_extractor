The extract_code_and_number postgres extension takes a phone number as text and returns a text array of [country_code, number_without_code]. It returns null if a country code was not found.