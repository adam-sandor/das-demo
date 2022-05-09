package transform.jumpcloud


all["users"] = users
all["groups"] = groups
all["role_bindings"] = role_bindings

role_bindings[g] = u {
  g :=  extract_group_name(input[_].memberOf[_])
  u := {"subjects":{"ids": array.concat([g], [u | users[u].groups[_] == g])}}
}

groups[g] = u {
  g :=  extract_group_name(input[_].memberOf[_])
  u := {"users":[u | users[u].groups[_] == g]}
}

extract_group_name(member) = cn {
  sections := split(member, ",")
  seg = split(sections[_], "=")
  seg[0] = "cn"
  cn := seg[1]
}

users[u] = user {
  u := input[i].uid[0]
  user := object.union_n([user_groups[u], user_string_attributes[u], user_int_attributes[u], computed_attributes(user_string_attributes[u], user_int_attributes[u])])
}

user_groups[u] = a {
  u := input[i].uid[0]
  a := {"groups": [g | g:= extract_group_name(input[i].memberOf[_])]}
}

STRING_ATTRIBUTES = {"physicalDeliveryOfficeName", "businessCategory", "postalAddress", "employeeType", "departmentNumber", "company", "title", "employeeNumber"}
user_string_attributes[u] = a {
  u := input[i].uid[0]
  a := {a:v | a := STRING_ATTRIBUTES[_]; v := input[i][a][0]}
}

INT_ATTRIBUTES = {"uidNumber", "gidNumber"}
user_int_attributes[u] = a {
  u := input[i].uid[0]
  a := {a:v | a := INT_ATTRIBUTES[_]; v := to_number(input[i][a][0])}
}

## Eric's modification below
## computed attributes based on input attributes

computed_attributes(string_attributes, int_attributes) = computed {
  role := string_attributes["employeeType"]
  role_level := to_number(last_element(split(string_attributes["title"], " ")))
  country := last_element(split(string_attributes["postalAddress"], "$"))
  geo_region := country_to_region_map[country]
  computed := {"role": role, "role_level": role_level, "country": country, "geo_region": geo_region}
}

last_element(array) = element {
  element := array[count(array) - 1]
}

country_to_region_map := {"AT": "EU", "BE": "EU", "BG": "EU", "HR": "EU", "CY": "EU", "CZ": "EU", "DK": "EU", "EE": "EU", "FI": "EU", "FR": "EU", "DE": "EU", "GR": "EU", "HU": "EU", "IE": "EU", "IT": "EU", "LV": "EU", "LT": "EU", "LU": "EU", "MT": "EU", "NL": "EU", "PL": "EU", "PT": "EU", "RO": "EU", "SK": "EU", "SI": "EU", "ES": "EU", "SE": "EU", "US": "US", "UK": "UK"}
