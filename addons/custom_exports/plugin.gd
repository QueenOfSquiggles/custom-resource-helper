tool
extends EditorPlugin

const MainPanel := preload("res://addons/custom_exports/ResourceManagerMenu.tscn")
const FALLBACK_ICON := preload("res://addons/custom_exports/custom_resource_default.png")

var main_panel_instance : ResourceManagerMenu


func _enter_tree() -> void:
	main_panel_instance = MainPanel.instance() as ResourceManagerMenu
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	make_visible(false)
	main_panel_instance.plugin_instance = self
	main_panel_instance.load_resource_types()

func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.remove_resource_types()
		main_panel_instance.queue_free()

func has_main_screen():
	return true


func make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

func get_plugin_name():
	return "Resource Types"


func get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return FALLBACK_ICON

func add_proxy(type: String, base: String, script: Script, icon: Texture) -> void:
	add_custom_type(type, base, script, icon)

func remove_proxy(type : String) -> void:
	remove_custom_type(type)
