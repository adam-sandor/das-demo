package transform.newinput

# This package is used to transform the input request from
# an existing schema to the Styra-supported entz schema.
# This is done by creating a rule here named "newinput" that
# translates the input to the Styra schema
#
# newinput := {
# 	"action": "CREATE",
# 	"context": {
# 		"channel": "API-MOBILE-BROWSER",
# 		"location": "China",
# 	},
# 	"groups": [
# 		"group1",
# 		"group2",
# 	],
#   "jwt": "jwt token",
# 	"resource": "aResource:action",
#   "resource-attributes": {
#     "attr1": "value1",
#     "attr2": "value2"
#   },
# 	"roles": [
# 		"aRole1",
# 		"aRole2",
# 	],
# 	"subject": "aSubject",
#   "subject-attributes": {
#     "attr1": "value1",
#     "attr2": "value2"
#   }
# }
#
