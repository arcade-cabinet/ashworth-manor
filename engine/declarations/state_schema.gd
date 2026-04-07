@tool
class_name StateSchema
extends Resource
## Every state variable in the game -- declared once, validated everywhere.

@export var variables: Array[StateVarDecl] = []
