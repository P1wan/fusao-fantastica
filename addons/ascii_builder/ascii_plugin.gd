@tool
extends EditorPlugin

func _enter_tree():
    add_tool_menu_item("Gerar Tutorial ASCII", Callable(self, "_build_ascii"))

func _exit_tree():
    remove_tool_menu_item("Gerar Tutorial ASCII")

func _build_ascii():
    var builder := load("res://addons/ascii_builder/ascii_level_builder.gd") as GDScript
    builder.new()._run()        # chama o EditorScript